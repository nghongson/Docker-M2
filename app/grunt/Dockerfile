FROM node:8.0-alpine
WORKDIR "/public_html"

RUN deluser --remove-home node
RUN addgroup -g 82 node \
  && adduser -u 1000 -G node -s /bin/sh -S node

RUN apk update && apk upgrade
RUN apk add --no-cache php7 php7-fpm
RUN apk search php
RUN apk add php7-json php7-xml php7-dom php7-pdo php7-pdo_mysql php7-simplexml php7-mcrypt php7-intl php7-xsl php7-zip php7-curl php7-gd php7-imagick

RUN npm install -g grunt-cli

USER node

CMD ["node"]
