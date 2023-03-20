@echo off

set PYTHON=
set GIT=
set VENV_DIR=
set COMMANDLINE_ARGS= --data-dir ../datago --vae-dir ../datago/models/VAE --embeddings-dir ../datago/embeddings --no-download-sd-model --opt-split-attention --lowvram --lowram

call webui.bat
