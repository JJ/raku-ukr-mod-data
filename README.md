# Using Raku to scrape and analyze Ukraine Ministry of Defense Data

News about combat losses of the Russian invaders are periodically published 
by the [Ukraininan minister of Defense](https://www.mil.gov.ua/en/news/) 
This is a [Raku](https://raku.org) module that extracts information from 
those pages, for instance [this one](https://www.mil.gov.
ua/en/news/2022/06/05/the-total-combat-losses-of-the-enemy-from-24-02-to-05-06/).

> Note: the English one is updated less frequently than the [Ukrainian one](https://www.mil.gov.ua/news/2022/06/08/vid-pochatku-povnomasshtabnoi-vijni-proti-ukraini-rosiya-vtratila-uzhe-1393-tanki-znishheno-703-artilerijskih-sistemi-voroga-%E2%80%93-generalnij-shtab-zs-ukraini/)
> At least there's a 2 day delay. I can't figure the later, unfortunately

## Installing

Clone this repo or install via `zef`

## Running

You can always check the examples in the `t` directory.

## See also

Failed tests for scraping are included in the `bin` directory. `scrapy.py` is
 functional, you will need to install the corresponding Python and Chrome
  dependencies.

* Download `chromedriver` from [here](https://www.google.com/search?channel=fs&client=ubuntu&q=%22chromedriver%22). You'll need to copy it by hand to the directory in the script, or anywhere else and change the script too.

Raw pages are included in the `raw-pages` directory. They are (c) the
 Ministry of Defense of Ukraine.

## License

This module is licensed under the Artistic 2.0 License (the same as Raku 
itself). See [LICENSE](LICENSE) for terms.
