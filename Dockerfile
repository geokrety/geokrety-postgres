FROM postgres:16-bullseye

COPY pgdg.preferences /etc/apt/preferences.d/pgdg

RUN apt-get update \
 && apt-get install -y --allow-downgrades \
      postgresql-14-postgis-3 \
      postgresql-14-postgis-3-scripts \
      postgis \
      postgresql-14-pgtap \
      make \
      gcc \
      postgresql-server-dev-14 \
      curl \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
 \
 && mkdir /tmp/pgxn \
 \
 && cd /tmp/pgxn \
 && curl -L https://github.com/tvondra/quantile/archive/244b6285e2c6a8d73bc555d7103200985e371bfa.tar.gz|tar xzf - \
 && cd /tmp/pgxn/quantile-244b6285e2c6a8d73bc555d7103200985e371bfa \
 && make install \
 \
 && cd /tmp/pgxn \
 && curl -L https://github.com/omniti-labs/pg_amqp/archive/240d477d40c5e7a579b931c98eb29cef4edda164.tar.gz|tar xzf - \
 && cd /tmp/pgxn/pg_amqp-240d477d40c5e7a579b931c98eb29cef4edda164 \
 && make install \
 \
 && cd / \
 && rm -fr /tmp/pgxn \
 && apt-get remove --purge -y \
      make \
      gcc \
      postgresql-server-dev-14 \
      curl

## Would have been nice to use pgnx to install `quantile` extension but required
# version is not currently available in pgxn
# See: https://github.com/tvondra/quantile/issues/12
