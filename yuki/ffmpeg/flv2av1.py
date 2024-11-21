#! /usr/bin/python3

import glob
import os
import logging
import sys
import signal
import json
import subprocess

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def set_logger(path: str) -> None:
    log_file = f'{path}/flv2av1.log'
    fh = logging.FileHandler(log_file, 'w')
    fh.setLevel(logging.INFO)
    fh.setFormatter(logging.Formatter("%(asctime)s\n%(message)s"))
    logger.addHandler(fh)

def get_bitrate_duration(path: str) -> tuple[float, str]:
    bitrate = 0.0
    duration = ''
    try:
        data = subprocess.run(f'ffprobe -v quiet -show_format -sexagesimal -print_format json {path}', shell=True, stdout=subprocess.PIPE).stdout
        json_data = json.loads(data)
        bitrate = int(json_data['format']['bit_rate'])/1000
        duration = json_data['format']['duration']
    except Exception as e:
        print(str(e))
    return bitrate, duration

def signal_handler(signal, frame):
  # your code here
  sys.exit(1)

def find_flv_files(path: str) -> list[str]:
    if not path.endswith('/'):
        path += '/'
    flv_files =  glob.glob(f'{path}**/*.flv', recursive=True)
    return_files = []
    last_mkv_file = ''
    last_origin_file = ''
    index_to_insert = 0
    for file in flv_files:
        mkv_file = file[:-3] + 'mkv'
        if os.path.exists(mkv_file):
            last_mkv_file = mkv_file
            last_origin_file = file
            # logger.info(f'mkv for {os.path.basename(file)} already exists.')
            # print(f'mkv for \33[94m{os.path.basename(file)}\33[0m already exists.')
        else:
            index_to_insert += 1
            return_files.append(file)
    print(f'Last mkv file is {last_mkv_file}')
    confirm = input('Delete it?: ')
    if confirm == 'y' or confirm == 'Y':
        os.remove(last_mkv_file)
        return_files.insert(index_to_insert, last_origin_file)
    return return_files


def print_files(files: list[str], prefix_str: str = None) -> None:
    prefix_len = 0
    if prefix_str:
        prefix_len = len(prefix_str) + 1

    print('\n\n')
    for index, file in enumerate(files):
        logger.info(f'{(index+1).__str__().ljust(8, " ")}{file[prefix_len:]}')
        print(f'{(index+1).__str__().ljust(8, " ")}{file[prefix_len:]}')
    print('\n\n')


def convert_av1(files: list[str]) -> None:
    for index, file in enumerate(files):
        # os.system('clear')
        output_mkv = file[:-3] + 'mkv'
        crf = 40
        bitrate, duration = get_bitrate_duration(file)
        if bitrate != 0.0:
            if bitrate < 2000:
                crf = 42
            if bitrate < 1000:
                crf = 45
        print(f'\n\n\33[92m{os.path.basename(file)}    [{index + 1} of {len(files)}]\33[0m\n\n')
        print(f"duration: {duration}, bitrate: {bitrate}, crf: {crf}")
        logger.info(f'[{index + 1} of {len(files)}] {os.path.basename(file)}\nduration: {duration}, bitrate: {bitrate}, crf: {crf}')
        command = f'ffmpeg -i "{file}" -c:v libsvtav1 -crf {crf} -preset 6 -svtav1-params tune=0:keyint=10s:film-grain-denoise=1:film-grain=12 -c:a libopus -b:a 128k -ac 2 -c:s copy "{output_mkv}"'
        os.system(command)


if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)

    base_path = input('Input path: ')
    set_logger(base_path)
    flv_files = find_flv_files(base_path)
    if not flv_files:
        print('No file will be convert.')
        exit(0)

    print_files(flv_files, prefix_str=base_path)
    confirm = input(f'Totle {len(flv_files)} files, convert?(Y/N): ')
    if confirm != 'y' and confirm != 'Y':
        exit(0)
    convert_av1(flv_files)

