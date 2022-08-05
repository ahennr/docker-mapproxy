#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:3.9-slim
LABEL maintainer="Sebastian Goetsch<goetsch@terrestris.de>"

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get install -y \
    libproj19 \
    python3-pyproj \
    python3-pil \
    python3-yaml \
    libgeos-dev \
    python3-lxml \
    libgdal-dev \
    python3-shapely \
    git

RUN pip install pyproj six werkzeug uwsgi 'MapProxy>1.15'
RUN pip install git+https://github.com/ahennr/mapproxy-rest-endpoint-plugin.git@d47300d00df4f614cd3bd637265634669fa1b695

COPY uwsgi.*.ini /opt/

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
