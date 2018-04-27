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

#date,time,total,used,free,shared,buff_cache,available,swap_total,swap_userd,swap_free
inputFile,performanceThreshold = getFile()
df = pd.read_csv(inputFile)

df = df.assign(util_mem = df['total'] - df['available'])
df = df.assign(util = (df['util_mem'] / df['total']) * 100)
#指定カラムを抽出: time,util
spec_columns = ['time','total','util_mem','util']
df = df[spec_columns]
df = df.query(str(performanceThreshold)  + ' <= util')
print('free_util_sumple' + '\t' + str(df.shape[0]))
print('free_util_mean' + '\t' + str(round(df['util'].mean(),1)))
print('free_util_median' + '\t' + str(round(df['util'].median(),1)))
sys.exit(0)

