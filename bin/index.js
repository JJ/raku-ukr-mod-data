const puppeteer = require("puppeteer");

async function snapScreenshot() {
  try {
    const URL =
      "https://www.mil.gov.ua/en/news/2022/06/03/the-total-combat-losses-of-the-enemy-from-24-02-to-03-06/";
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.goto(URL);
    await page.screenshot({ path: "screenshot.png" });

    await browser.close();
  } catch (error) {
    console.error(error);
  }
}

snapScreenshot();
