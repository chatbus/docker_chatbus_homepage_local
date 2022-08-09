# base image ubuntu
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

LABEL Name="docker-nextjs-local Version=0.0.1"
LABEL maintainer="Donny Seo <jams7777@gmail.com>"

# Install wget and install/updates certificates node
RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						apt-utils gnupg ca-certificates bzip2 apt-transport-https \
                        cron supervisor automake autotools-dev build-essential \
    					gettext-base libelf1 \
						cron vim curl ssh git unzip nodejs \
	&& curl -sL https://deb.nodesource.com/setup_16.x | bash - \
	&& apt-get install -y nodejs \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && apt-get update && apt-get install yarn && rm -rf /var/lib/apt/lists/*

ENV NPM_CONFIG_LOGLEVEL debug
ENV NODE_VERSION 16.16.0

# work dir make
RUN mkdir /app
RUN chmod 777 -R /app
RUN mkdir /app/web
RUN chmod 777 -R /app/web
RUN mkdir /app/web2
RUN chmod 777 -R /app/web2

# Install npm lastest
RUN /usr/bin/npm install npm -g
RUN /usr/bin/npm install -g pnpm

# package copy
COPY ./package.json /app/web2/package.json

# node_module root
RUN cd /app/web2 && pnpm install

# homepage root
WORKDIR /app/web

# exec shell setting
COPY ./start.sh /root/start.sh
RUN chmod 777 /root/start.sh

# alais setting
RUN  echo "alias app='cd /app/web'" >> /root/.bashrc
RUN  echo "alias app2='cd /app/web2'" >> /root/.bashrc
RUN  echo "alias start='/root/start.sh'" >> /root/.bashrc

RUN  echo "echo " >> /root/.bashrc
RUN  echo "echo " >> /root/.bashrc
RUN  echo "echo ' ************         danbee.Ai Next.js Local [ local ]     ************* ' " >> /root/.bashrc
RUN  echo "echo ' *****                                                            ******* ' " >> /root/.bashrc
RUN  echo "echo ' ***** << Alias >>                                                ******* ' " >> /root/.bashrc
RUN  echo "echo ' *****       app : app                                            ******* ' " >> /root/.bashrc
RUN  echo "echo ' *****       app2: app lib                                        ******* ' " >> /root/.bashrc
RUN  echo "echo ' *****     start : start dev next server                          ******* ' " >> /root/.bashrc
RUN  echo "echo ' ************************************************************************ ' " >> /root/.bashrc

# Volume setting
VOLUME ["/app/web", "/app/web2"]

# Port setting
EXPOSE 3000

CMD ["/bin/bash"]
