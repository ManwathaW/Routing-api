FROM openrouteservice/openrouteservice:v9.9.0

EXPOSE 8082

# Active config + Limpopo map data
COPY ./ors-docker/config/ors-config.yml /home/ors/config/ors-config.yml
COPY ./ors-docker/files/limpopo.osm.pbf /home/ors/files/limpopo.osm.pbf

ENV ORS_CONFIG_LOCATION=/home/ors/config/ors-config.yml
# /home/ors/graphs is backed by a Railway volume. Normally we set this to
# False so graphs persist across restarts, but cached graphs from previous
# attempts were built with mismatched config and are causing
# HillIndexGraphStorageBuilder errors at load time. Set to True for ONE
# deploy to clear and rebuild, then flip back to False.
ENV REBUILD_GRAPHS=True
# railway.toml [env] pins these (and wins over Dockerfile ENV at runtime).
# XMX=1g lets graph build complete on the Limpopo extract; smaller heap OOMs.
ENV XMS=256m
ENV XMX=1g
ENV CONTAINER_LOG_LEVEL=INFO
