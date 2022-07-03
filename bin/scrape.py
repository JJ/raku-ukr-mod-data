#!/usr/bin/env python

""" Script to download data from the MoD directory.
    `days` is a dictionary with months as keys, an array
    of the days that are going to be downloaded as value.
    """

import sys

from ukr_mod_data import main, download_today
sys.path.append(".")
sys.path.append("..")

if not sys.argv[1]:
    download_today()
else:
    main({sys.argv[1]: [sys.argv[2]]})
