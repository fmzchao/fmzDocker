# fmzDocker

docker run -d --name FMZDocker -e UID=XXXXXX -e PASSWORD=XXXXXX -e REGION=com fmzcom/docker:latest

docker run -d --name FMZDocker -e UID=XXXXXX -e PASSWORD=XXXXXX -e REGION=cn fmzcom/docker:latest

如果您的 fmzcom/docker 仓库中已经有一个标签为 latest 的镜像,您可以按照以下步骤更新该镜像:

1. 登录 Docker Hub:
   在终端中运行以下命令,使用您的 Docker Hub 账号进行登录:

    ```
    docker login
    ```

    输入您的 Docker Hub 用户名和密码进行认证。

2. 构建 Docker 镜像:
   在 Dockerfile 所在的目录下,运行以下命令构建 Docker 镜像,并将其标记为 latest:

    ```
    docker build -t fmzcom/docker:latest .
    ```

    这将使用您修改后的 Dockerfile 构建一个新的镜像,并将其标记为 latest。

3. 推送镜像到 Docker Hub:
   构建完成后,使用以下命令将镜像推送到 fmzcom/docker 仓库:

    ```
    docker push fmzcom/docker:latest
    ```

    这将把新构建的镜像推送到 Docker Hub,覆盖现有的 latest 标签镜像。

    推送过程可能需要一些时间,具体取决于镜像的大小和网络速度。推送完成后,您的最新镜像将替换 fmzcom/docker 仓库中原有的 latest 标签镜像。

4. 验证镜像:
   在 Docker Hub 网站上,进入 fmzcom/docker 仓库页面,确认 latest 标签已经更新为新推送的镜像。您还可以使用`docker pull`命令从 Docker Hub 拉取最新的镜像,以验证镜像是否已经更新:

    ```
    docker pull fmzcom/docker:latest
    ```

    如果拉取成功,说明 latest 标签已经成功更新为新的镜像。

请注意,当您将新镜像推送到 Docker Hub 时,使用 latest 标签意味着您将覆盖现有的 latest 标签镜像。如果您想保留旧版本的镜像,可以考虑使用其他标签,如版本号或日期,来标识不同的镜像版本。

如有任何问题,请随时告诉我。
