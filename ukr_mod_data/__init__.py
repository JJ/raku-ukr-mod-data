"""_Downloads pages from the Ukrainian MoD using chromedriver;
    A file with the same name will be saved in the `raw-pages` directory.
"""

import time
import random
import sys
import re
from datetime import date

import undetected_chromedriver as uc

driver = uc.Chrome(
    driver_executable_path='/opt/google/chrome/chromedriver', headless=True
)


def download(day, month):
    """_Downloads a single page, checks if there's the right regex there,
    sleeps for a random time after

    Args:
        day ( int ): day of the month, used to build the URL. It will be 0 padded
        month ( str ): 0-padded month.
    """
    # pylint: disable=line-too-long
    url = f'https://www.mil.gov.ua/en/news/2022/{month}/{day}/the-total-combat-losses-of-the-enemy-from-24-02-to-{day:02}-{month}/'
    print("⬇️ Download " + url)
    driver.get(url)
    return driver.page_source

def save_if_correct( content, day, month ):
    """ Save content to a file with pre-established name only if correct"""
    filename = f'raw-pages/combat-losses-to-{day}-{month} |.html'
    print("💾 saving " + filename)
    if re.search(r"about\s+\d+", content):
        with open(filename, "w", encoding='utf-8') as file:
            file.write(content)
    else:
        print(f'Download for {month}-{day} does not contain the required data')



def main(days) -> int:
    """ Proceeds to generate URLs and download them using the corresponding function
    Args:
        days (hash): hash with months-days to download
    """
    if len(sys.argv) > 1:
        download( sys.argv[1], sys.argv[2])
    else:
        for month in days:
            for day in days[month]:
                content = download(day, month)
                save_if_correct(content, day, month)
                sleeping = random.randrange(5, 15)
                print(f'⌛ waiting for {sleeping}')
                time.sleep(sleeping)


def download_today():
    """ Download the losses URL corresponding to today's date"""
    print("Downloading today's data")
    today = date.today()
    print(today)
    sys.exit(main({f'{today.month:02}': [f'{today.day:02}']}))


if __name__ == '__main__':
    download_today()
