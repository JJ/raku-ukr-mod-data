import undetected_chromedriver as uc
import time
import random
import sys


def download(driver, day, month):
    # pylint: disable=line-too-long
    url = f'https://www.mil.gov.ua/en/news/2022/{month}/{day}/the-total-combat-losses-of-the-enemy-from-24-02-to-{day:02}-{month}/'
    print("⬇️ Download " + url)
    driver.get(url)
    filename = f'raw-pages/The total combat losses of the enemy from 24.02 to {day}.{month} | Міноборони.html'
    print("💾 saving " + filename)
    with open(filename, "w") as file:
        file.write(driver.page_source)
    sleeping = random.randrange(5, 15)
    print(f'⌛ waiting for {sleeping}')
    time.sleep(sleeping)


driver = uc.Chrome(
    driver_executable_path='/opt/google/chrome/chromedriver', headless=True
)


def main(days) -> int:
    if len(sys.argv) > 1:
        download(driver, sys.argv[1], sys.argv[2])
    else:
        for month in days:
            for day in days[month]:
                download(driver, day, month)


if __name__ == '__main__':
    sys.exit(main())
