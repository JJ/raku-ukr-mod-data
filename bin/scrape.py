#!/usr/bin/env python

""" Script to download data from the MoD directory.
    `days` is a dictionary with months as keys, an array
    of the days that are going to be downloaded as value.
    """

from ukr_mod_data import main
import sys
sys.path.append(".")
sys.path.append("..")


days = {}

if not sys.argv[1]:
    days = {
        "06": list(range(27, 9, -1)),
    }
else:
    days = {sys.argv[1]: [sys.argv[2]]}

main(days)
