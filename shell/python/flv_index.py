import os
import subprocess

# 配置参数（根据需求修改）
input_dir = "D:\\input\\videos"       # 输入目录（需要处理的视频目录）
output_dir = "D:\\output\\videos"     # 输出目录（处理后的视频保存位置）
ffmpeg_params = {                   # FFmpeg参数（按需修改）
    'c': 'copy',
    'flvflags': 'add_keyframe_index',
    #'c:v': 'libx265',               # 视频编码器
    #'crf': '23',                    # 视频质量（0-51，越小质量越高）
    #'preset': 'medium',             # 编码速度与压缩率平衡
    #'c:a': 'aac',                   # 音频编码器
    #'b:a': '128k',                  # 音频码率
    #'s': '1280x720',                # 分辨率（留空则不修改分辨率）
}
video_exts = ('.mp4', '.avi', '.mov', '.mkv', '.flv')  # 支持处理的视频格式

def main():
    # 检查FFmpeg可用性
    try:
        subprocess.run(['ffmpeg', '-version'], check=True, 
                      stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except FileNotFoundError:
        print("错误：未找到FFmpeg，请安装并添加到系统PATH环境变量")
        return

    # 创建输出目录
    os.makedirs(output_dir, exist_ok=True)

    # 遍历输入目录处理视频
    for filename in os.listdir(input_dir):
        if filename.lower().endswith(video_exts):
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(
                output_dir,
                f"{os.path.splitext(filename)[0]}_processed.mp4"  # 输出文件名格式
            )

            # 构建FFmpeg命令
            cmd = ['ffmpeg', '-i', input_path, '-y']  # -y覆盖已存在文件
            for key, value in ffmpeg_params.items():
                if value:  # 跳过值为空的参数
                    cmd.extend([f'-{key}', str(value)])
            cmd.append(output_path)

            # 执行命令
            try:
                #print(' '.join(cmd)) # 查看实际执行的FFmpeg命令
                subprocess.run(cmd, check=True)
                print(f"✅ 成功处理：{filename}")
            except subprocess.CalledProcessError as e:
                print(f"❌ 处理失败：{filename}（错误码 {e.returncode}）")

if __name__ == "__main__":
    main()