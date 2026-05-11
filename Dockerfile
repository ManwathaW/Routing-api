FROM openrouteservice/openrouteservice:v9.9.0

EXPOSE 8082

# Active config + Limpopo map data
COPY ./ors-docker/config/ors-config.yml /home/ors/config/ors-config.yml
COPY ./ors-docker/files/limpopo.osm.pbf /home/ors/files/limpopo.osm.pbf

ENV ORS_CONFIG_LOCATION=/home/ors/config/ors-config.yml
# On Railway the container filesystem is ephemeral, so graphs are rebuilt on
# every deploy. REBUILD_GRAPHS=False just avoids forcing a rebuild when graphs
# already exist (e.g. when running locally with a volume).
ENV REBUILD_GRAPHS=False
# Tuned for Railway hobby plan (~500 MB container). Do NOT raise XMX above 1g
# without also upgrading the plan — the JVM will OOM during graph build.
ENV XMS=256m
ENV XMX=1g
ENV CONTAINER_LOG_LEVEL=INFO
