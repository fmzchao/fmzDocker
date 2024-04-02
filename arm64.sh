#!/bin/bash

docker build -t fmzcom/docker-arm64 -f Dockerfile.arm64 .

docker push fmzcom/docker-arm64