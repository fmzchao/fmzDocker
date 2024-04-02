#!/bin/bash
/bin/bash amd64.sh
/bin/bash arm64.sh

docker manifest push fmzcom/docker