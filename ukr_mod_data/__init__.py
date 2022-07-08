"""_Downloads pages from the Ukrainian MoD using
    `undetected_chromedriver`;
    A file with a formatted name will be saved in the raw_pages directory.
"""

import time
import random
import sys
import os
import re
from datetime import date

import undetected_chromedriver as uc

LOCAL_CHRPATH = '/opt/google/chrome/chromedriver'
# pylint: disable=invalid-name
# driver = None
# if os.getenv('LOCAL_CHRPATH'):
#print(f" [⚠️] Using driver {LOCAL_CHRPATH}")
driver = uc.Chrome(
    driver_executable_path=LOCAL_CHRPATH, headless=True
)
# else:
#    print(f' [⚠️] Using default chromedriver')
#    driver = uc.Chrome(headless=True)


def download(day, month):
    """_Downloads a single page, checks if there's the right regex there,
    sleeps for a random time after

    Args:
        day ( int ): day of the month, used to build the URL. It will be 0 padded
        month ( str ): 0-padded month.
    """
    # pylint: disable=line-too-long
    url = f'https://www.mil.gov.ua/en/news/2022/{month}/{day}/the-total-combat-losses-of-the-enemy-from-24-02-to-{day}-{month}/'
    print("⬇️ Download " + url)
    driver.get(url)
    if not driver.page_source:
        print("No source downloaded")
        sys.exit(1)
    return driver.page_source


def save_if_correct(content, day, month):
    """ Save content to a file with pre-established name only if correct,
    that is, if it includes losses data"""
    filename = f'raw-pages/combat-losses-to-{day}.{month} |.html'
    print("💾 saving " + filename)
    if re.search(r"p>personnel", content):
        with open(filename, "w", encoding='utf-8') as file:
            file.write(content)
    else:
        print(f'Download for {month}-{day} does not contain the required data')
        print(content)


def main(days) -> int:
    """ Proceeds to generate URLs and download them using the corresponding function
    Args:
        days (hash): hash with months-days to download
    """
    if len(sys.argv) > 1:
        download(sys.argv[1], sys.argv[2])
    else:
        for month in days:
            for day in days[month]:
                content = download(day, month)
                save_if_correct(content, day, month)
                sleeping = random.randrange(5, 15)
                print(f'⌛ waiting for {sleeping}')
                time.sleep(sleeping)


def download_today():
    """ Download the VSRF losses report URL corresponding to today's date"""
    print("Downloading today's data")
    today = date.today()
    sys.exit(main({f'{today.month:02}': [f'{today.day:02}']}))


if __name__ == '__main__':
    download_today()
