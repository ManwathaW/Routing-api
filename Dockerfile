FROM openrouteservice/openrouteservice:v9.9.0

EXPOSE 8082

# Active config + Limpopo map data
COPY ./ors-docker/config/ors-config.yml /home/ors/config/ors-config.yml
COPY ./ors-docker/files/limpopo.osm.pbf /home/ors/files/limpopo.osm.pbf

ENV ORS_CONFIG_LOCATION=/home/ors/config/ors-config.yml
# /home/ors/graphs is backed by a Railway volume so the built graphs persist
# across restarts. With this set to False, ORS loads existing graphs in a few
# seconds instead of rebuilding the ~100s graph build on every redeploy.
# Flip to True only if config changes invalidate the cached graphs.
ENV REBUILD_GRAPHS=False
# railway.toml [env] pins these (and wins over Dockerfile ENV at runtime).
# XMX=1g lets graph build complete on the Limpopo extract; smaller heap OOMs.
ENV XMS=256m
ENV XMX=1g
ENV CONTAINER_LOG_LEVEL=INFO
