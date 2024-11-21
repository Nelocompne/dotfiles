#! /usr/bin/python3

import glob
import os
import logging
import subprocess
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def set_logger(path: str) -> None:
    log_file = f'{path}/rm.log'
    fh = logging.FileHandler(log_file, 'w')
    fh.setLevel(logging.INFO)
    fh.setFormatter(logging.Formatter("%(asctime)s\n%(message)s"))
    logger.addHandler(fh)

def get_bitrate(path: str) -> float:
    bitrate = 0.0
    try:
        data = subprocess.run(f'ffprobe -v quiet -show_format -print_format json {path}', shell=True, stdout=subprocess.PIPE).stdout
        json_data = json.loads(data)
        bitrate = int(json_data['format']['bit_rate'])/1000
    except Exception as e:
        print(str(e))
    return bitrate

def find_flv_mkv_files(path: str) -> list[tuple[str, str]]:
    if not path.endswith('/'):
        path += '/'
    mkv_files =  glob.glob(f'{path}**/*.mkv', recursive=True)
    return_files = []
    for file in mkv_files:
        flv_file = file[:-3] + 'flv'
        return_files.append((flv_file, file))
    return return_files

def rm_larger(files: list[tuple[str, str]], base_path: str = None) -> None:
    path_len = len(base_path) + 1
    rm_files = []
    flv_count = 0
    mkv_count = 0
    for ft in files:
        flv_size = os.path.getsize(ft[0])
        mkv_size = os.path.getsize(ft[1])
        if mkv_size > flv_size:
            rm_files.append(ft[1])
            mkv_count += 1
        else:
            pass
            # rm_files.append(ft[0])
            # flv_count += 1
    logger.info('list:')
    print('list:')
    for f in rm_files:
#        mkv_bitrate = get_bitrate(f)
#        flv_bitrate = get_bitrate(f[:-3]+'flv')
        mkv_bitrate=0
        flv_bitrate=0
        logger.info(f'{f[path_len:]}\nflv bitrate: {flv_bitrate}kbps, mkv bitrate:{mkv_bitrate}kbps')
        print(f'{f[path_len:]}\nflv bitrate: {flv_bitrate}kbps, mkv bitrate:{mkv_bitrate}kbps')
    logger.info(f'Total flv files: {flv_count}, mkv files: {mkv_count}')
    print(f'Total flv files: {flv_count}, mkv files: {mkv_count}')
    confirm = input(f'Delete?: ')
    if confirm != 'y' and confirm != 'Y':
        os.exit(0)
    for f in rm_files:
        os.remove(f)

if __name__ == '__main__':
    base_path = input('Input path: ')
    set_logger(base_path)
    files = find_flv_mkv_files(base_path)
    if not files:
        print('Nothing to do')
        os.exit(0)
    rm_larger(files, base_path)


