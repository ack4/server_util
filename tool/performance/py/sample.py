#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
basedir = os.path.dirname(os.path.abspath(sys.argv[0]))
sys.path.insert(0, os.path.join(basedir, 'modules/numpy'))
sys.path.insert(0, os.path.join(basedir, 'modules/pandas'))

def check_args():
    if len(sys.argv) < 2:
        print("args error")
        sys.exit(99)
    else:
        if not os.path.exists(sys.argv[1]):
            print("not exists file")
            sys.exit(99)

check_args()
exit(0)

import numpy as np
import pandas as pd

#np_data = np.mean(np.loadtxt("list.csv",delimiter=',',skiprows=1),axis=0)

#date,time,r,b,swpd,free,buff,cache,si,so,bi,bo,in,cs,us,sy,id,wa,st
#row:73,columns:19
df = pd.read_csv('result_conv_vmstat.csv')

#row num
#print df.shape[0]
#column num
#print df.shape[1]

#指定カラムを抽出: time,us,sy,wa,st,id
#spec_columns = ['time','bi','bo','us','sy','wa','st','id']
#df = df[spec_columns]

#idleが90%以下のレコードを抽出
#print df.query('id < 90')

#次の条件で新規列(istest)を追加:idleが90以下(高負荷)
df = df.assign(istest = (df['id'] < 90).astype(int))

#df_line = df.apply(lambda x: x['us'] + x['sy'] + x['wa'] + x['st'],axis=1)
#指定カラムで各レコードごとに値を合計したシリーズデータをテーブルに新規追加
df_line = df['us'] + df['sy'] + df['wa'] + df['st']
df = df.assign(cpu = df_line)

#データフレームをout.csvとして出力
#df.to_csv("out.csv",index=False,encoding="utf8")

#負荷が掛かっている区間の統計レポートを出力する
#print df.query('istest == 1').describe()

mean = df.mean()
median = df.median()

