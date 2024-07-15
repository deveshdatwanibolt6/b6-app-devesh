curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

python3 -m venv venv

source ./venv/bin/activate

pip3 install --no-cache-dir -r requirements.txt 