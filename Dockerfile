FROM postgres:16-bullseye

COPY pgdg.preferences /etc/apt/preferences.d/pgdg

RUN apt-get update \
 && apt-get install -y --allow-downgrades \
      postgresql-17-postgis-3 \
      postgresql-17-postgis-3-scripts \
      postgis \
      postgresql-17-pgtap \
      make \
      gcc \
      postgresql-server-dev-17 \
      curl \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
 \
 && mkdir /tmp/pgxn \
 \
 && cd /tmp/pgxn \
 && curl -L https://github.com/kumy/pg_amqp/archive/refs/heads/patch-1.tar.gz|tar xzf - \
 && cd /tmp/pgxn/pg_amqp-patch-1 \
 && make install \
 \
 && cd / \
 && rm -fr /tmp/pgxn \
 && apt-get remove --purge -y \
      make \
      gcc \
      postgresql-server-dev-17 \
      curl
