FROM node:16.14.0 as build

LABEL maintainer = "zouzhujia <1844066417@qq.com>"

# 设置环境变量
# 参数后面不能有空格
ENV APP_ENV='local'

# 奇怪dockerfile文件不能放到目录里面，使用../会导致失败
ADD . /var/www/blog_vuepress

WORKDIR /var/www/blog_vuepress

RUN set -ex \
  && yarn install \
  && echo -e "\033[42;37m Yarn Install Completed :).\033[0m\n" \
  && yarn build \
  && echo -e "\033[42;37m Build Install Completed :).\033[0m\n"

FROM nginx:1.18

# 从某个容器里面复制出来
COPY --from=build /var/www/blog_vuepress/docs/.vuepress/dist /var/www/blog_vuepress
COPY --from=build /var/www/blog_vuepress/nginx.conf /etc/nginx/conf.d/

RUN echo -e "\033[42;37m Nginx copy Completed :).\033[0m\n"

WORKDIR /var/www/blog_vuepress

EXPOSE 8080:8080
