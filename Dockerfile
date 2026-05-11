FROM openrouteservice/openrouteservice:v9.9.0

EXPOSE 8082

# Active config + Limpopo map data
COPY ./ors-docker/config/ors-config.yml /home/ors/config/ors-config.yml
COPY ./ors-docker/files/limpopo.osm.pbf /home/ors/files/limpopo.osm.pbf

ENV ORS_CONFIG_LOCATION=/home/ors/config/ors-config.yml
# Graphs are persisted in the image layer; rebuild only when the .pbf or config
# changes (bump this or set REBUILD_GRAPHS=True at runtime to force).
ENV REBUILD_GRAPHS=False
ENV XMS=512m
ENV XMX=1500m
ENV CONTAINER_LOG_LEVEL=INFO
