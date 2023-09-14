FROM --platform=linux/amd64 ubuntu:22.04

LABEL maintainer="coo@fmz.com"
WORKDIR /app

RUN apt-get update && apt-get install wget tar libc6 -y
RUN wget https://www.fmz.com/dist/robot_linux_amd64.tar.gz
RUN tar -xzf robot_linux_amd64.tar.gz
RUN chmod +x robot
RUN rm robot_linux_amd64.tar.gz

CMD ["sh","-c","if [ -z $REGION ]; then echo 'Please provide the REGION environment variable.' && exit 1; fi && if [ -z $UID ]; then echo 'Please provide the UID as environment variable.' && exit 1; fi && if [ -z $PASSWORD ]; then echo 'Please provide the PASSWORD as environment variable.' && exit 1; fi && ./robot -s node.fmz.$REGION/$UID -p $PASSWORD"]