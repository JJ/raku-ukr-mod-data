#!/usr/bin/env python

import undetected_chromedriver as uc
import io

driver = uc.Chrome(
    driver_executable_path='/opt/google/chrome/chromedriver', headless=True
)
driver.get("https://www.mil.gov.ua/en/news/2022/05/25/the-total-combat-losses-of-the-enemy-from-24-02-to-25-05/")
print(driver.page_source)
