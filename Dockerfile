# Dockerizing Redis 32 bit
# https://github.com/docker-library/redis/
FROM quay.io/inok/baseimage

RUN apt-get update \
	&& apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

ENV REDIS_VERSION 3.0.0
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.0.0.tar.gz
ENV REDIS_DOWNLOAD_SHA1 c75fd32900187a7c9f9d07c412ea3b3315691c65

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN buildDeps='gcc libc6-dev libc6-dev-i386 g++-multilib make'; \
	set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/redis \
	&& curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
	&& echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
	&& rm redis.tar.gz \
	&& make CFLAGS="-m32 -march=native" LDFLAGS="-m32" -C /usr/src/redis \
	&& make -C /usr/src/redis install \
	&& rm -r /usr/src/redis \
	&& apt-get purge -y --auto-remove $buildDeps

RUN mkdir /data
VOLUME /data
WORKDIR /data

CMD [ "redis-server", "/data/redis.conf" ]
