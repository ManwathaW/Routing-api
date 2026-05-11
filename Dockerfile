FROM openrouteservice/openrouteservice:v9.9.0

# Railway will provide the PORT env var, but ORS runs on 8082 by default
EXPOSE 8082

# Copy the configuration file to where the entrypoint actually looks for it
COPY ./ors-docker/config/ors-config.yml /home/ors/config/ors-config.yml

# Copy the Limpopo map data into the container
COPY ./ors-docker/files/limpopo.osm.pbf /home/ors/files/limpopo.osm.pbf

# Tell ORS where to find the config
ENV ORS_CONFIG_LOCATION=/home/ors/config/ors-config.yml
ENV REBUILD_GRAPHS=True
ENV XMS=200m
ENV XMX=400m
ENV CONTAINER_LOG_LEVEL=INFO
