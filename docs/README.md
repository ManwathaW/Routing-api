# API testing

## Postman collection

[`Routing-API.postman_collection.json`](./Routing-API.postman_collection.json) is a ready-to-import Postman collection covering every endpoint on the routing API.

### Import

1. Open Postman → **Import** (top left)
2. Drop the JSON file in (or paste its URL from GitHub)
3. The collection appears in the left sidebar as **Limpopo Routing API (OpenRouteService)**

### What's inside

| Folder | Endpoint | What it does |
|---|---|---|
| Service | `GET /ors/v2/health` | Liveness check — returns `{"status":"ready"}` |
| Service | `GET /ors/v2/status` | Which profiles are loaded, PBF version, build date |
| Directions | `GET /ors/v2/directions/{profile}` | Simple GET routing — start/end as query params |
| Directions | `POST /ors/v2/directions/{profile}/geojson` | Full options: preference, units, language, instructions |
| Directions | `POST .../geojson` (waypoints) | Route through multiple stops |
| Matrix | `POST /ors/v2/matrix/{profile}` | N×N distance + duration grid between many points |
| Isochrones | `POST /ors/v2/isochrones/{profile}` | Reachability polygons (e.g. "everywhere reachable in 10 min") |
| Snap | `POST /ors/v2/snap/{profile}` | Nearest routable point on the road network |

### Variables

Two collection variables you can override per-environment:

- **`baseUrl`** — defaults to the Railway prod URL. Set to `http://localhost:8080` if running locally via `docker-compose`.
- **`profile`** — defaults to `driving-car`. Switch to `foot-walking` for walking routes.

### Things to know

- **No auth required** — the instance is open.
- **Coordinate order is `longitude, latitude`** (not the usual lat,lng). The sample requests all have the right order — copy the structure when adding new ones.
- **Coverage is currently Limpopo only.** Requests with start/end outside that region will fail with `Could not find routable point`. We'll lift this when the country-wide map switch lands.
- For drawable responses (route lines on a map), use `Accept: application/geo+json`. For plain data, use `Accept: application/json`.

### Reference

Full ORS API spec: https://giscience.github.io/openrouteservice/api-reference/
