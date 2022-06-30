#!/usr/bin/env python

import sys
import os
sys.path.append(".")
sys.path.append("..")

from ukr_mod_data import main

days ={}

if days == {}:
    days = {
        "06": [i for i in range(27, 9, -1)],
    }
else:
    days = { sys.argv[1]: [sys.argv[2]] }

main(days)
