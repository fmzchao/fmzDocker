#!/bin/bash

# 退出脚本如果有任何命令失败
set -e

# 设置镜像名称和版本
IMAGE_NAME="youquant/docker"
VERSION="latest"

# 定义支持的架构
architectures=("linux_amd64" "linux_aarch64")

# 根据 IMAGE_NAME 选择 Dockerfile
if [[ "$IMAGE_NAME" == *"fmzcom"* ]]; then
    DOCKERFILE="Dockerfile.fmzcom"
else
    DOCKERFILE="Dockerfile.youquant"
fi

echo "使用的 Dockerfile: $DOCKERFILE"

# 循环构建并推送每个架构的镜像
for ARCH in "${architectures[@]}"; do
    echo "正在构建架构: $ARCH"

    # 构建 Docker 镜像，传递架构参数，使用选定的 Dockerfile
    docker build -t ${IMAGE_NAME}:${ARCH}-${VERSION} --build-arg ARCH=$ARCH -f $DOCKERFILE .

    # 推送构建的镜像到 Docker 仓库
    docker push ${IMAGE_NAME}:${ARCH}-${VERSION}
done

# 检查 manifest 是否存在
if docker manifest inspect ${IMAGE_NAME}:${VERSION} > /dev/null 2>&1; then
    echo "Manifest 已存在，将进行更新"
    MANIFEST_CREATE_CMD="docker manifest create --amend"
else
    echo "Manifest 不存在，将创建新的"
    MANIFEST_CREATE_CMD="docker manifest create"
fi

# 创建或更新 Docker manifest 列表
$MANIFEST_CREATE_CMD ${IMAGE_NAME}:${VERSION} \
    ${IMAGE_NAME}:linux_amd64-${VERSION} \
    ${IMAGE_NAME}:linux_aarch64-${VERSION}

# 为每个架构的镜像添加注释
docker manifest annotate ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:linux_amd64-${VERSION} --os linux --arch amd64
docker manifest annotate ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:linux_aarch64-${VERSION} --os linux --arch arm64

# 推送 manifest 列表到 Docker 仓库
docker manifest push ${IMAGE_NAME}:${VERSION}

echo "成功构建并推送镜像和 manifest: ${IMAGE_NAME}:${VERSION}"