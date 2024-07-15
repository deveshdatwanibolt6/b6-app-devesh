sudo docker build -t b6-app:latest ./app/

sudo docker run --rm -d -p 5000:5000 b6-app 