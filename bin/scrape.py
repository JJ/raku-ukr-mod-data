#!/usr/bin/env python

import undetected_chromedriver as uc
import time
import random

driver = uc.Chrome(
    driver_executable_path='/opt/google/chrome/chromedriver', headless=True
)
days = {"02": [28],
        "03": [i for i in range(1, 31)],
        "04": [i for i in range(1, 30)],
        "05": [i for i in range(1, 26)]
        }

for month in days:
    for day in days[month]:
        url = f'https://www.mil.gov.ua/en/news/2022/05/25/the-total-combat-losses-of-the-enemy-from-24-02-to-{day}-{month}/'
        print("⬇️ Download " + url)
        driver.get(url)
        filename = f'raw-pages/The total combat losses of the enemy from 24.02 to {day}.{month} | Міноборони.html'
        print("💾 saving " + filename)
        with open(filename, "w") as file:
            file.write(driver.page_source)
        sleeping = random.randrange(5, 15)
        print(f'⌛ waiting for {sleeping}')
        time.sleep(sleeping)
