#!/usr/bin/env python

from selenium import webdriver
import io

options = webdriver.ChromeOptions()
options.add_argument("--headless")
# Change chromedriver path accordingly
driver = webdriver.Chrome("/opt/google/chrome/chromedriver", options=options)
driver.get("https://www.mil.gov.ua/en/news/2022/05/25/the-total-combat-losses-of-the-enemy-from-24-02-to-25-05/")
driver.implicitly_wait(30)
html = driver.page_source
with io.open(driver.title + ".html", "w", encoding="utf-8") as f:
    f.write(html)
    f.close()
driver.quit()
