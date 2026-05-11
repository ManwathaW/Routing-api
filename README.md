# 🗺️ Local Maps — OpenRouteService

> A self-hosted routing and navigation engine for **South Africa**.  
> Powered by [OpenRouteService](https://openrouteservice.org/) and [OpenStreetMap](https://www.openstreetmap.org/) data.

---

## 📋 Project Overview

| Spec | Detail |
|---|---|
| **Engine** | OpenRouteService v9.9.0 |
| **Runtime** | Docker (via Docker Compose) |
| **Region** | South Africa |
| **Bounding Box** | `-34.8, 16.4` → `-22.1, 32.9` |
| **Data Source** | OpenStreetMap (Overpass API export) |
| **Data Format** | `.osm` (XML) |
| **Data Size** | ~408 MB |
| **API Port** | `8080` (mapped from container port `8082`) |
| **Monitoring Port** | `9001` (optional) |
| **API Base URL** | `http://localhost:8080/ors/v2/` |

---

## 🚗 Enabled Routing Profiles

| Profile | Description | Status |
|---|---|---|
| `driving-car` | Car/vehicle routing with turn costs, toll detection, road access restrictions | ✅ Enabled |
| `foot-walking` | Pedestrian routing with hill index and trail difficulty data | ✅ Enabled |

### Profiles Available (Not Enabled)

These profiles can be enabled in `ors-docker/config/ors-config.yml`:

- `driving-hgv` — Heavy goods vehicle routing
- `cycling-regular` — Standard cycling
- `cycling-mountain` — Mountain biking
- `cycling-road` — Road cycling
- `cycling-electric` — E-bike routing
- `foot-hiking` — Hiking routes
- `wheelchair` — Wheelchair-accessible routes
- `public-transport` — Public transport (requires GTFS data)

---

## 🛠️ Technical Specifications

### Docker Container

| Property | Value |
|---|---|
| **Image** | `openrouteservice/openrouteservice:v9.9.0` |
| **Container Name** | `ors-app` |
| **Exposed Ports** | `8080:8082`, `9001:9001` |
| **JVM Min Memory** | 1 GB (`-Xms1g`) |
| **JVM Max Memory** | 2 GB (`-Xmx2g`) |
| **Log Level** | `INFO` |
| **CORS** | Enabled (`*` — all origins allowed) |

### Map Data

| Property | Value |
|---|---|
| **Source File** | `south-africa-latest.osm.pbf` |
| **Format** | OpenStreetMap XML |
| **Size** | ~408 MB |
| **Region** | South Africa |
| **Latitude Range** | -34.8 to -22.1 |
| **Longitude Range** | 16.4 to 32.9 |
| **Provider** | Overpass API (overpass-api.de) |

### Elevation Data

| Property | Value |
|---|---|
| **Provider** | SRTM (Shuttle Radar Topography Mission) |
| **Tiles Used** | `srtm_42_17`, `srtm_43_17` |
| **Cache Size** | ~188 MB (zips + extracted `.gh` files) |
| **Auto-Downloaded** | Yes (on first container start) |

### Routing Graphs

| Profile | Approx. Size | Features |
|---|---|---|
| `driving-car` | ~1.2 GB | Edges, nodes, turn costs, CH/Core shortcuts, landmarks, toll/access data |
| `foot-walking` | ~800 MB | Edges, nodes, hill index, trail difficulty, landmarks |

---

## 📂 File Structure

```
Local maps/
│
├── README.md                        ← This file
├── openrouteservice-file-structure.md  ← Detailed file-by-file breakdown
├── docker-compose.yml               ← Docker Compose config
├── south-africa-latest.osm.pbf      ← Raw OSM data (backup)
│
├── map-ui/
│   └── index.html                   ← Interactive Leaflet map UI for testing routes
│
└── ors-docker/                      ← ORS runtime directory (mounted into container)
    ├── config/
    │   ├── ors-config.yml           ← Active configuration
    │   ├── example-ors-config.yml   ← Full reference config
    │   └── example-ors-config.env   ← Environment variable reference
    ├── files/
    │   ├── south-africa-latest.osm.pbf  ← Map data used by ORS
    │   └── example-heidelberg.test.pbf  ← Default test data
    ├── elevation_cache/             ← SRTM elevation tiles (auto-downloaded)
    ├── graphs/                      ← Pre-built routing graphs
    │   ├── driving-car/             ← Vehicle routing graph
    │   └── foot-walking/            ← Pedestrian routing graph
    └── logs/
        └── ors.log                  ← Application log
```

---

## 🚀 Getting Started

### Prerequisites

- **Docker Desktop** installed and running
- **4 GB RAM** minimum (3-4 GB allocated to JVM recommended for South Africa)
- **~3 GB disk space** (images + data + massive routing graphs)

### 1. Start the Service

```powershell
cd "C:\Users\WANGA MANWATHA\Desktop\Local maps"
docker compose up -d
```

### 2. Wait for Graphs to Build

On first launch, ORS will:
1. Download elevation data (~100+ MB) — takes several minutes
2. Build national routing graphs — takes 5–10 minutes

### 3. Check Health

```powershell
Invoke-RestMethod http://localhost:8080/ors/v2/health
```

Expected response when ready:
```json
{ "status": "ready" }
```

### 4. Open the Map UI

```powershell
Invoke-Item "C:\Users\WANGA MANWATHA\Desktop\Local maps\map-ui\index.html"
```

Click on the map to set start and destination points, then see the calculated route.

---

## 🔌 API Endpoints

### Health Check
```
GET http://localhost:8080/ors/v2/health
```

### Directions (Driving)
```
GET http://localhost:8080/ors/v2/directions/driving-car?start={lon},{lat}&end={lon},{lat}
```

### Directions (Walking)
```
GET http://localhost:8080/ors/v2/directions/foot-walking?start={lon},{lat}&end={lon},{lat}
```

### Example — Drive across South Africa (Cape Town to Johannesburg)
```
GET http://localhost:8080/ors/v2/directions/driving-car?start=18.4233,-33.9249&end=28.0473,-26.2041
```

### Example — Walk across South Africa (Cape Town to Johannesburg)
```
GET http://localhost:8080/ors/v2/directions/foot-walking?start=18.4233,-33.9249&end=28.0473,-26.2041
```

### Available Endpoints (When Enabled)

| Endpoint | Path | Description |
|---|---|---|
| **Directions** | `/ors/v2/directions/{profile}` | Point-to-point routing |
| **Isochrones** | `/ors/v2/isochrones/{profile}` | Reachability areas |
| **Matrix** | `/ors/v2/matrix/{profile}` | Distance/time matrix between multiple points |
| **Snap** | `/ors/v2/snap/{profile}` | Snap coordinates to nearest road |
| **Export** | `/ors/v2/export/{profile}` | Export routing graph data |
| **Health** | `/ors/v2/health` | Service health check |
| **Status** | `/ors/v2/status` | Detailed service status |

---

## ⚙️ Configuration

The active configuration is at `ors-docker/config/ors-config.yml`.

### Enable Additional Profiles

Edit `ors-config.yml` and add profiles under `ors.engine.profiles`:

```yaml
ors:
  engine:
    profiles:
      driving-car:
        enabled: true
      foot-walking:
        enabled: true
      cycling-regular:    # Add this
        enabled: true
```

Then rebuild graphs:

```powershell
cd "C:\Users\WANGA MANWATHA\Desktop\Local maps"
docker compose down
Remove-Item -Recurse -Force .\ors-docker\graphs\*
docker compose up -d
```

### Change Map Region

1. Download new OSM data from [Overpass API](https://overpass-api.de/) or [Geofabrik](https://download.geofabrik.de/)
2. Place the `.osm` or `.osm.pbf` file in `ors-docker/files/`
3. Update `source_file` in `ors-config.yml`
4. Clear graphs and restart

### Increase Memory (for larger datasets)

In `docker-compose.yml`, adjust:

```yaml
environment:
  XMS: 2g   # start RAM
  XMX: 4g   # max RAM
```

**Rule of thumb:** `XMX = PBF_size × num_profiles × 2`

---

## 🛑 Stopping the Service

```powershell
cd "C:\Users\WANGA MANWATHA\Desktop\Local maps"
docker compose down
```

---

## 📊 Disk Usage Summary

| Component | Size |
|---|---|
| Docker image | ~350 MB |
| OSM source data | ~408 MB |
| Elevation cache | ~500 MB |
| Driving-car graphs | ~1.2 GB |
| Foot-walking graphs | ~800 MB |
| **Total** | **~3.2 GB** |

---

## 🚀 Railway Deployment Guide

This project is configured and ready to be deployed to Railway for free/low-cost cloud hosting.

### Step 1: Push to GitHub
1. Open a terminal in the `Local maps` folder.
2. Initialize a git repository: `git init`
3. Add all files: `git add .` (The `.gitignore` will ensure large cache files are excluded).
4. Commit: `git commit -m "Initial commit"`
5. Create a new repository on GitHub and follow their instructions to push this code.

### Step 2: Deploy the Backend (OpenRouteService)
1. Go to [Railway.app](https://railway.app/) and sign in with GitHub.
2. Click **New Project** -> **Deploy from GitHub repo**.
3. Select your repository.
4. Railway will automatically detect the `Dockerfile` in the root directory and start building the backend.
5. **Note:** The first build will take 10-20 minutes as it downloads terrain and builds the national graphs.
6. Once deployed, go to the service **Settings** -> **Networking** and click **Generate Domain**. Save this URL!

### Step 3: Deploy the Frontend (Map UI)
You can host the frontend on Railway from the exact same repository!
1. In your Railway Project dashboard, click the **New** button (top right).
2. Select **GitHub Repo** and choose the same repository again.
3. Railway will add a second service. Before it builds, click on this new service, go to **Settings**.
4. Scroll down to **Root Directory** and change it to `/map-ui`.
5. Railway will instantly recognize it as a static website and deploy it using a fast web server.
6. Go to **Networking** for this frontend service and **Generate Domain**. This is your public website URL!

### Step 4: Connect Them
1. Open your local `map-ui/index.html` file.
2. Change the `ORS_BASE_URL` to the backend domain you generated in Step 2:
   ```javascript
   const ORS_BASE_URL = 'https://your-backend-app.up.railway.app/ors/v2';
   ```
3. Commit and push this change to GitHub. Railway will automatically rebuild the frontend, and your live website will now talk to your live backend!

---

## 📚 References

- [OpenRouteService Documentation](https://giscience.github.io/openrouteservice/)
- [ORS Docker Guide](https://giscience.github.io/openrouteservice/run-instance/running-with-docker)
- [ORS Configuration Reference](https://giscience.github.io/openrouteservice/run-instance/configuration/)
- [ORS API Playground](https://openrouteservice.org/dev/#/api-docs)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Geofabrik Downloads](https://download.geofabrik.de/)

---

## 📝 License

- **OpenRouteService** — [LGPL 3.0](https://github.com/GIScience/openrouteservice/blob/main/LICENSE)
- **OpenStreetMap Data** — [ODbL](https://opendatacommons.org/licenses/odbl/)
