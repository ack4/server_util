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

#date,time,r,b,swpd,free,buff,cache,si,so,bi,bo,in,cs,us,sy,id,wa,st
#row:73,columns:19
inputFile,performanceThreshold = getFile()
df = pd.read_csv(inputFile)

#指定カラムを抽出: time,us,sy,wa,st,id
spec_columns = ['time','us','sy','wa','st','id']
df = df[spec_columns]
df = df.assign(cpu = 100 - df['id'])
df = df.assign(flg = (performanceThreshold <= df['cpu']).astype(int))
df = df.query('flg == 1')

print('cpu_sumple' + '\t' + str(df.shape[0]))
print('cpu_mean' + '\t' + str(round(df['cpu'].mean(),1)))
print('cpu_median' + '\t' + str(round(df['cpu'].median(),1)))
sys.exit(0)

