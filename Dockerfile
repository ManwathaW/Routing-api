FROM openrouteservice/openrouteservice:v9.9.0

EXPOSE 8082

# Active config + Limpopo map data
COPY ./ors-docker/config/ors-config.yml /home/ors/config/ors-config.yml
COPY ./ors-docker/files/limpopo.osm.pbf /home/ors/files/limpopo.osm.pbf

ENV ORS_CONFIG_LOCATION=/home/ors/config/ors-config.yml
# /home/ors/graphs is backed by a Railway volume so graphs persist across
# restarts. With REBUILD_GRAPHS=False, ORS builds graphs on first start (when
# the volume is empty) and reuses them on every subsequent restart.
ENV REBUILD_GRAPHS=False
# Tuned for Railway hobby plan. railway.toml [env] also pins these (and wins
# over Dockerfile ENV at runtime). Anything larger than XMX=400m gets the JVM
# OOM-killed by the container even when heap "Used" looks fine, because
# native + metaspace + GC overhead push real RSS past the container limit.
ENV XMS=200m
ENV XMX=400m
ENV CONTAINER_LOG_LEVEL=INFO
