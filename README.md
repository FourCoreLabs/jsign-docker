# JSign Docker

> A convenient Docker image for code signing with JSign

## Overview

This repository builds and publishes Docker images that package [JSign](https://github.com/ebourg/jsign) - a powerful Java-based code signing tool. The image is built using `jpackage` to provide a streamlined command-line experience for all your code signing needs.

## Features

- **Always Updated**: Automatically tracks the latest JSign releases
- **Simple Interface**: Exposes the JSign binary for straightforward command-line usage
- **Cross-Platform**: Run consistently across any environment that supports Docker
- **Minimal Size**: Optimized image with only the necessary dependencies

## Usage

```bash
# Pull the latest image
docker pull ghcr.io/FourCoreLabs/jsign-docker:latest

# Run JSign with your parameters
docker run --rm -v $(pwd):/work ghcr.io/FourCoreLabs/jsign-docker jsign [options]
```

### Example: Signing a Windows executable

```bash
docker run --rm \
  -v $(pwd):/work \
  ghcr.io/FourCoreLabs/jsign-docker \
  jsign --keystore mycert.pfx \
        --storepass mypassword \
        --storetype PKCS12 \
        --tsaurl http://timestamp.digicert.com \
        myapplication.exe
```

## Versioning

Each image is tagged with both:
- The specific JSign version (e.g., `7.1`)
- The `latest` tag for the most recent build

## License

This Docker packaging is provided under MIT license. JSign itself is licensed under Apache License 2.0.
