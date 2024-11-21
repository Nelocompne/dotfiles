#! /usr/bin/python

import glob
import os

base_path = input('Input path: ')
if not base_path.endswith('/'):
    base_path += '/'

flvs = glob.glob(f'{base_path}**/*.flv', recursive=True)
mkvs = glob.glob(f'{base_path}**/*.mkv', recursive=True)

fsize, msize = 0, 0
for f in flvs:
    fsize += os.path.getsize(f)
for f in mkvs:
    msize += os.path.getsize(f)

ps = msize / fsize * 100
fsize = fsize / 1024 / 1024 / 1024
msize = msize / 1024 / 1024 / 1024
print(f'flv size: {fsize}G, mkv size: {msize}G ({ps}%)')
