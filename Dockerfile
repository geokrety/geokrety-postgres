FROM postgres:12.2

RUN apt-get update \
 && apt-get install -y \
      postgresql-12-postgis-3 \
      postgresql-12-postgis-3-scripts \
      postgis \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
