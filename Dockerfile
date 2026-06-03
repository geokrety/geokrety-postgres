FROM timescale/timescaledb:2.27.2-pg16-oss

COPY pg_amqp-compile-fix.patch /tmp/pgxn/pg_amqp-compile-fix.patch

RUN apk add --no-cache \
      geos \
      proj \
      gdal \
      libxml2 \
      json-c \
      protobuf-c \
      postgresql-contrib \
      postgresql-client \
      curl \
      tar \
 && apk add --no-cache --virtual .build-deps \
       build-base \
       make \
       perl \
       gcc \
       pkgconf \
       bash \
       ca-certificates \
       patch \
       clang \
       llvm \
       geos-dev \
       proj-dev \
       gdal-dev \
       libxml2-dev \
       json-c-dev \
       protobuf-c-dev \
 && mkdir -p /tmp/postgis \
 && cd /tmp/postgis \
 && curl -L https://download.osgeo.org/postgis/source/postgis-3.6.2.tar.gz | tar xzf - \
 && cd /tmp/postgis/postgis-3.6.2 \
 && ./configure --with-pgconfig=/usr/local/bin/pg_config \
 && make -j$(nproc) \
 && make install \
 && cd / \
 && rm -fr /tmp/postgis \
 \
 && mkdir -p /tmp/pgtap \
 && curl -L https://github.com/theory/pgtap/archive/refs/tags/v1.3.4.tar.gz | tar xzf - -C /tmp/pgtap \
 && cd /tmp/pgtap/pgtap-1.3.4 \
 && make PG_CONFIG=/usr/local/bin/pg_config \
 && make install PG_CONFIG=/usr/local/bin/pg_config \
 && cd / \
 && rm -fr /tmp/pgtap \
 \
 && cd /tmp/pgxn \
 && curl -L https://github.com/kumy/pg_amqp/archive/refs/heads/patch-1.tar.gz | tar xzf - \
 && ln -sf /usr/bin/clang /usr/bin/clang-19 || true \
 && cd /tmp/pgxn/pg_amqp-patch-1 \
 && patch -p1 < /tmp/pgxn/pg_amqp-compile-fix.patch \
 && make install \
 && cd / \
 && rm -fr /tmp/pgxn \
 && apk del .build-deps
