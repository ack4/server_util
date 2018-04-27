#!/usr/bin/env python2
# -*- coding: utf-8 -*-

def time_sleep(sec):
  """引数時間sleepする"""
  import time
  time.sleep(sec)

def mkdir_here(target_dir):
  """ディレクトリ作成後、絶対パス返却"""
  import os
  #tmp_file = os.path.join(tmp_dir,"tmp.txt")
  abs_dir = os.path.abspath(target_dir)
  if not os.path.exists(abs_dir):
    os.makedirs(abs_dir)
  return abs_dir

def get_dir():
  """ディレクトリ情報をタプルで返却
  return00:スクリプト名
  return01:スクリプトディレクトリ
  return02:カレントディレクトリ
  return03:ホームディレクトリ"""
  import os
  import sys
  base_script_name = os.path.basename(sys.argv[0])
  base_script_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
  current_dir = os.getcwd()
  home_dir = os.environ.get('HOME',"")
  #下記はモジュール化した際にモジュールのパスが取得されてしまうため却下
  #base_script_dir = os.path.abspath(__file__)
  return (base_script_name,base_script_dir,current_dir,home_dir)

def sub_process(command):
  """subprocessモジュールでOSコマンドの実施(os,commondsモジュールは非推奨)"""
  import subprocess
  try:
    res = subprocess.check_output(command)
  except:
    print("ERROR:exec '%s' error." %command)

def request_http(req_url,req_method):
  """HTTPリクエスト(GET)レスポンスボディを複数の配列で返す(urllibはpython3_only)"""
  import urllib.request
  req = urllib.request.Request(req_url,method=req_method)
  req.add_header('Referer','test_referer.com')
  req.add_header('User-Agent','test_user_agent')
  with urllib.request.urlopen(req) as f:
    req_arr_org = f.read().decode('utf-8').split('\n')
    #新しいオブジェクトIDで配列copyを生成
    import copy
    req_arr_mod = copy.deepcopy(req_arr_org)
    req_arr_mod.sort()
    req_arr_mod.reverse()
    #print(id(req_arr_org))
    #print(id(req_arr_mod))
    #タプルで複数の配列参照を返す
    return (req_arr_org,req_arr_mod)

def get_args():
  """コマンドライン引数の取得"""
  import sys
  import copy
  args = copy.deepcopy(sys.argv)
  if len(args) <= 1:
    return None
  return args[1:]

def file_rw(file_path,mode):
  """ファイル読み書き"""
  if mode == 'r':
    with open(file_path,mode) as f_read:
      for row in f_read:
        print(row.strip())
  elif mode == 'w':
    with open(file_path,mode) as f_write:
      f_write.write("@test write@")
  else:
    print("ERROR:args_error")

def sqlite3_test():
  import sqlite3
  db = sqlite3.connect(":memory:")
  cdb = db_mem.cursor()
  db.close()

def insert_gz_csv(db_file,table_name,csv_header,insert_header,csv_data):
  import sqlite3
  import csv
  import gzip
  db = sqlite3.connect(db_file)
  #db.text_factory = str
  cur_db = db.cursor()
  with gzip.open(csv_data,'rt') as f:
    reader = csv.reader(f)
    cur_db.execute("CREATE TABLE {0} ({1})".format(table_name,','.join(insert_header)))
    insert_sql = "INSERT INTO {0}({1}) VALUES(:{2})"\
        .format(table_name,','.join(insert_header),',:'.join(insert_header))
    for row in reader:
      dic = dict(zip(csv_header,row))
      cur_db.execute(insert_sql,dic)
  db.commit()
  res = cur_db.execute("SELECT * FROM {0} LIMIT 3".format(table_name))
  for i in res:
    print(i)
  db.close()

######メイン処理
print("@@@start@@@")
#db_file="pysql.db"
db_file=":memory:"
table_name="tbl"
csv_header="date,time,info,thread,byte,dest,messageid,telegram,mode,code1,code2,tran,result,destinfo"
csv_header=tuple(csv_header.split(','))
#insert_header="date,time,telegram"
insert_header="date,time,info,thread,byte,dest,messageid,telegram,mode,code1,code2,tran,result"
insert_header=tuple(insert_header.split(','))
csv_data="ifs.csv.gz"
insert_gz_csv(db_file,table_name,csv_header,insert_header,csv_data)

exit(0)

import os
print("@@@start@@@")
base_script_name,base_script_dir,current_dir,home_dir = get_dir()
if not base_script_dir == current_dir:
  print("カレントディレクトリとスクリプトディレクトリが違います")
else:
  target_dir = mkdir_here(os.path.join(base_script_dir,"tmp"))
  #target_dir = mkdir_here(os.path.join(base_script_dir,"tmp","test"))

file_rw("%s/%s" % (target_dir,"test.log"),'w')
print("end")
exit(0)


#タプルで文字列を渡している(引数は一つ)
#abs_dir = mkdir_here("tmp_%s_%s" % ('new','_dir'))
#タプル型の複数戻り値の多重代入
#get1,get2,get3 = get_env()
#sproc = sub_process("ls")
#arr_org,arr_mod = request_http("http://architechnica.sakura.ne.jp/","GET")
#get_args()

