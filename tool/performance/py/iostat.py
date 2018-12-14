#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
basedir = os.path.dirname(os.path.abspath(sys.argv[0]))
sys.path.insert(0, os.path.join(basedir, 'modules/numpy'))
sys.path.insert(0, os.path.join(basedir, 'modules/pandas'))

def getFile():
    if len(sys.argv) < 2:
        print("ERRRO:args error.")
        sys.exit(99)
    else:
        if not os.path.exists(sys.argv[1]):
            print("ERRRO:not exists file.")
            sys.exit(99)
        elif len(sys.argv) == 2:
            #default performance threshold -> 3% 
            return [sys.argv[1],3]
        elif len(sys.argv) == 3:
            return [sys.argv[1],int(sys.argv[2])]
        else:
            print("ERRRO:valuse error.")
            sys.exit(99)

import numpy as np
import pandas as pd

#datetime,Device,rrqm/s,wrqm/s,r/s,w/s,rMB/s,wMB/s,avgrq-sz,avgqu-sz,await,r_await,w_await,svctm,util
#row:73,columns:19
inputFile,performanceThreshold = getFile()
df = pd.read_csv(inputFile)
#
##指定カラムを抽出: datetime,util
spec_columns = ['datetime','util']
df = df[spec_columns]
df = df.query(str(performanceThreshold)  + ' <= util')
print('iostat_util_sumple' + '\t' + str(df.shape[0]))
print('iostat_util_mean' + '\t' + str(round(df['util'].mean(),1)))
print('iostat_util_median' + '\t' + str(round(df['util'].median(),1)))
sys.exit(0)

