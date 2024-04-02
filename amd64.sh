#!/bin/bash

docker build -t fmzcom/docker-amd64 -f Dockerfile.amd64 .

docker push fmzcom/docker-amd64