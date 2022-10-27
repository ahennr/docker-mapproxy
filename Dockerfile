#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:3.10-slim
LABEL maintainer="terrestris GmbH & Co. KG <info@terrestris.de>"

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get update && apt-get install -y \
    libproj19 \
    python3-pyproj \
    python3-pil \
    python3-yaml \
    libgeos-dev \
    python3-lxml \
    libgdal-dev \
    build-essential \
    python-dev \
    python3-shapely \
    && rm -rf /var/lib/apt/lists/*

RUN pip install MapProxy==1.15.1 pyproj uwsgi six werkzeug

EXPOSE 8080

ADD uwsgi.conf /uwsgi.conf

ADD start.sh /start.sh

RUN chmod 0755 /start.sh

CMD /start.sh
