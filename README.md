# jsign-docker

This repository builds the latest [jsign](https://github.com/ebourg/jsign) release and packages it into a self-contained Docker image using `jpackage`. The resulting image exposes the `jsign` binary, making it easy to use `jsign` without installing Java or any dependencies.

## 🐳 Docker Image

The Docker image is published to **GitHub Container Registry (GHCR)**:

```
ghcr.io/FourCoreLabs/jsign-docker:latest
```

It is also version-tagged automatically based on the latest jsign release, for example:

```
ghcr.io/FourCoreLabs/jsign-docker:7.1
```

## 🚀 Usage

You can use the container just like the `jsign` CLI:

```bash
docker run --rm ghcr.io/FourCoreLabs/jsign-docker --help
```

To sign a JAR file:

```bash
docker run --rm \
  -v $(pwd):/data \
  ghcr.io/FourCoreLabs/jsign-docker \
  /data/your-app.jar --alias YOUR_ALIAS ...
```

## 🛠️ How It Works

- Downloads the latest `jsign` release from GitHub.
- Uses `jpackage` to create a lightweight application image.
- The built Docker image includes only what's needed to run `jsign`.

## 💪 Build It Yourself

```bash
docker build -t jsign-docker --build-arg JSIGN_VERSION=7.1 .
```

## 📦 GHCR Publishing

A GitHub Actions workflow automatically:

- Fetches the latest jsign version
- Builds the Docker image
- Publishes it to GHCR
- Tags it with both `:latest` and the version number

