# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Optional: Needed to run a remote script the first time
# from scoop.sh

# 确保安装好python，推荐安装3.10版本，最新版尚未完全支持

python -m venv ./venv
. venv\Scripts\Activate.ps1
pip install torch==1.13.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117 xformers
pip install -r requirements.txt

# deactivate 退出venv环境