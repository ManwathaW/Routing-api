FROM openrouteservice/openrouteservice:v9.9.0

# Railway will provide the PORT env var, but ORS runs on 8082 by default
# We expose it so Railway can map it automatically
EXPOSE 8082

# Copy the configuration file into the container
# ORS expects the config to be available either via mount or baked in
COPY ./ors-docker/config/ors-config.yml /home/ors/ors-core/openrouteservice/src/main/resources/ors-config.yml

# Download the South Africa map data directly from Geofabrik to bypass GitHub size limits
RUN mkdir -p /home/ors/files && \
    wget -O /home/ors/files/south-africa-latest.osm.pbf https://download.geofabrik.de/africa/south-africa-latest.osm.pbf

# Set environment variables for ORS to find the files
ENV ORS_CONFIG_LOCATION=/home/ors/ors-core/openrouteservice/src/main/resources/ors-config.yml
ENV BUILD_GRAPHS=True
