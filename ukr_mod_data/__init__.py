"""_Downloads pages from the Ukrainian MoD using chromedriver;
    A file with the same name will be saved in the `raw-pages` directory.
"""

import time
import random
import sys
from datetime import date

import undetected_chromedriver as uc

driver = uc.Chrome(
    driver_executable_path='/opt/google/chrome/chromedriver', headless=True
)


def download(drv, day, month):
    """_Downloads a single page, sleeps for a random time after

    Args:
        driver ( ChromeDriver ): driver used to download
        day ( int ): day of the month, used to build the URL. It will be 0 padded
        month ( str ): 0-padded month.
    """
    # pylint: disable=line-too-long
    url = f'https://www.mil.gov.ua/en/news/2022/{month}/{day}/the-total-combat-losses-of-the-enemy-from-24-02-to-{day:02}-{month}/'
    print("⬇️ Download " + url)
    drv.get(url)
    filename = f'raw-pages/The total combat losses of the enemy from 24.02 to {day}.{month} | Міноборони.html'
    print("💾 saving " + filename)
    with open(filename, "w", encoding='utf-8') as file:
        file.write(drv.page_source)
    sleeping = random.randrange(5, 15)
    print(f'⌛ waiting for {sleeping}')
    time.sleep(sleeping)


def main(days) -> int:
    """ Proceeds to generate URLs and download them using the corresponding function
    Args:
        days (hash): hash with months-days to download
    """
    if len(sys.argv) > 1:
        download(driver, sys.argv[1], sys.argv[2])
    else:
        for month in days:
            for day in days[month]:
                download(driver, day, month)


def download_today():
    print("Downloading today's data")
    today = date.today()
    print(today)
    sys.exit(main({f'{today.month:02}': [f'{today.day:02}']}))


if __name__ == '__main__':
    download_today()
