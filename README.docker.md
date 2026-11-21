# Humanizer WebUI Docker

This image serves the upstream Humanizer editor and uses the LM Studio OpenAI-compatible server on the host. It does not download or run model weights.

## Start

1. In LM Studio, start the local server and load a Humanizer model.
2. Run `docker compose up --build -d` from this directory.
3. Open http://localhost:47616.

The menu has only the engine restart action. Since the model engine belongs to LM Studio, restarting it from this UI reconnects/restarts the Humanizer service state; it does not restart LM Studio's model process.

## Settings

Set these Docker environment parameters in `docker-compose.yml` or your deployment UI. The provider must expose OpenAI-compatible `/models` and `/chat/completions` endpoints.

You can override them without editing the Compose file:

```bash
LLM_PROVIDER=lm-studio \
LLM_API=http://host.docker.internal:1234/v1 \
LLM_MODEL=humanizer@q6_k \
docker compose up -d
```

Supply `LLM_TOKEN` through the deployment environment if your provider requires a Bearer token. `LLM_PROVIDER` is a display name in the server logs. The `HUMANIZER_EXTERNAL_*` variables are supported as fallbacks. The WebUI checks `/models` before reporting ready.

Data is stored in the named Docker volume `humanizer-data` (launcher settings/logs; the editor history remains in the browser). To stop, run `docker compose down`.

## Synology Container Manager

Copy the repository files into the NAS project folder. Create a Container Manager project from `compose.synology.yml` in that folder. The YAML builds the image from the included Dockerfile.

Set `HUMANIZER_PUBLIC_ORIGIN` to the URL you use to open the WebUI, including the port, and set `LLM_API` to the model server's LAN address or HTTPS API base URL. Set `LLM_TOKEN` through the project's deployment environment, or in a private copy of the YAML on the NAS. Keep the token out of Git. The sample uses port 47616 and is intended for a trusted LAN.

## Upstream and licensing

This WebUI is based on [sgaofen/humanizer-local-model](https://github.com/sgaofen/humanizer-local-model).

The upstream application code is Apache-2.0. This deployment is a modified build of the upstream repository.
