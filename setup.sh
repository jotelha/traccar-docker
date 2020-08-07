# docker compose

mkdir -p ${HOME}/venv
python -m venv ${HOME}/venv/containers-python-3.6
source ${HOME}/venv/containers-python-3.6/bin/activate
pip install --upgrade pip
pip install pyyaml
pip install git+https://github.com/jotelha/podman-compose.git@20200524_down_timeout

