#!/usr/bin/env python

import sys
import os
sys.path.append(".")
sys.path.append("..")

from ukr_mod_data import main

days = days = {
    "06": [i for i in range(27, 9, -1)],
}
main(days)
