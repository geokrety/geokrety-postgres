FROM postgres:12.2

RUN apt-get update \
 && apt-get install -y \
      postgresql-12-postgis-3 \
      postgresql-12-postgis-3-scripts \
      postgis \
      postgresql-12-pgtap \
      make \
      gcc \
      postgresql-server-dev-12 \
      curl \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
 && mkdir /tmp/pgxn \
 && cd /tmp/pgxn \
 && curl -L https://github.com/tvondra/quantile/archive/244b6285e2c6a8d73bc555d7103200985e371bfa.tar.gz|tar xzf - \
 && cd /tmp/pgxn/quantile-244b6285e2c6a8d73bc555d7103200985e371bfa \
 && make install \
 && cd .. \
 && rm -fr /tmp/pgxn/quantile-244b6285e2c6a8d73bc555d7103200985e371bfa \
 && apt-get remove --purge -y \
      make \
      gcc \
      postgresql-server-dev-12 \
      curl

## Would have been nice to use pgnx to install `quantile` extension but required
# version is not currently available in pgxn
# See: https://github.com/tvondra/quantile/issues/12
