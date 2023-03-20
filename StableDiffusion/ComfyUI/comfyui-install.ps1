python -m venv ./venv
. venv\Scripts\Activate.ps1
pip install torch==1.13.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117 xformers
pip install -r requirements.txt
# deactivate 退出venv环境