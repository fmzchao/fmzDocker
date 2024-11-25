# cat pass.txt
DOCKER_BUILDKIT=0 docker build -t fmzcom/docker:latest .
#docker run -d --name FMZDocker -e UID=xxxx -e PASSWORD=xxxx fmzcom/docker:latest
docker push fmzcom/docker:latest


docker build -t youquant/docker:latest .
# docker run -d --name YouQuant -e UID=xxxx -e PASSWORD=xxxx youquant/docker:latest
docker push youquant/docker:latest

podman logout docker.io