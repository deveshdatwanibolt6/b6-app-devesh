FROM alpine:latest

COPY . . 

RUN apk update  && \
	apk add --update --no-cache python3 && \
	apk add py3-pip && \
	python3 -m venv venv && \
	source ./venv/bin/activate

RUN apk add py3-flask

CMD ["flask", "--app", "b6-app", "run", "-h", "0.0.0.0"]
