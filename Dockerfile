FROM python:3.6-slim-buster

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PORT 5000
ENV USERNAME admin
ENV PASSWORD admin
ENV OPENSSL_CONF /etc/ssl/
ENV MY_SECRET_KEY='@c*hlphantomjs^i9c9&0w86&@2!d)fb*r$up1cf!hhnlyf_@&'

COPY . /app

WORKDIR /app


# && wget https://github.com/mjysci/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux_${OS_ARCH}.tar.gz -O /tmp/phantomjs-2.1.1-linux_${OS_ARCH}.tar.gz \
# && tar -xzvf /tmp/phantomjs-2.1.1-linux_${OS_ARCH}.tar.gz -C /usr/local/bin \



RUN set -x; buildDeps='wget build-essential' \
&& apt-get update && apt-get install -y ${buildDeps} \ 
chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev \
&& rm -rf /var/lib/apt/lists/* \
&& export OS_ARCH=$(uname -m) \
&& wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-${OS_ARCH}.tar.bz2 -O /tmp/phantomjs-2.1.1-linux-${OS_ARCH}.tar.bz2 \
&& tar -xvjf /tmp/phantomjs-2.1.1-linux-${OS_ARCH}.tar.bz2 -C /usr/local/bin \
&& mv /usr/local/bin/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/ \
&& rm /usr/local/bin/phantomjs-2.1.1-linux-x86_64 \
&& rm /tmp/phantomjs-2.1.1-linux-${OS_ARCH}.tar.bz2 \
&& pip install -r requirements.txt && pip cache purge \
&& apt-get purge -y --auto-remove $buildDeps

EXPOSE $PORT

RUN chmod +x run.sh
CMD ./run.sh $PORT $USERNAME $PASSWORD