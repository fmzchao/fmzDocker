#!/bin/bash

# 启用错误追踪和详细输出
set -ex

# 设置镜像名称和版本
IMAGE_NAME="fmzcom/docker"
VERSION="latest"

# 定义支持的架构
architectures=("amd64" "arm64")

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
    
    # 根据架构设置ARCH参数
    if [ "$ARCH" == "amd64" ]; then
        BUILD_ARCH="linux_amd64"
    elif [ "$ARCH" == "arm64" ]; then
        BUILD_ARCH="linux_aarch64"
    else
        echo "不支持的架构: $ARCH"
        continue
    fi
    
    # 构建 Docker 镜像，传递架构参数，使用选定的 Dockerfile
    docker build -t ${IMAGE_NAME}:${ARCH}-${VERSION} --build-arg ARCH=$BUILD_ARCH -f $DOCKERFILE .
    
    # 推送构建的镜像到 Docker Hub
    docker push ${IMAGE_NAME}:${ARCH}-${VERSION}
    
    # 验证推送是否成功
    docker pull ${IMAGE_NAME}:${ARCH}-${VERSION}
done

# 删除旧的 manifest（如果存在）
docker manifest rm ${IMAGE_NAME}:${VERSION} || true

echo "创建新的 Manifest..."
# 创建新的 Docker manifest 列表
docker manifest create ${IMAGE_NAME}:${VERSION} \
    ${IMAGE_NAME}:amd64-${VERSION} \
    ${IMAGE_NAME}:arm64-${VERSION}

# 为每个架构的镜像添加注释，移除 amd64 的 variant 标记
docker manifest annotate ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:amd64-${VERSION} --os linux --arch amd64 --variant ""
docker manifest annotate ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:arm64-${VERSION} --os linux --arch arm64 --variant "v8"

# 推送 manifest 列表到 Docker Hub
docker manifest push --purge ${IMAGE_NAME}:${VERSION}

# 验证 manifest 是否正确创建
docker manifest inspect ${IMAGE_NAME}:${VERSION}

echo "成功构建并推送镜像和 manifest 到 Docker Hub: ${IMAGE_NAME}:${VERSION}"

# 尝试拉取镜像以验证
docker pull ${IMAGE_NAME}:${VERSION}

echo "脚本执行完毕。请检查上面的输出是否有任何错误。"