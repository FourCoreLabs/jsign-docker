FROM eclipse-temurin:21 AS builder

# Argument for the Jsign version (required at build time)
# Pass this during build: --build-arg JSIGN_VERSION=5.0 (replace 5.0 with the desired version)
ARG JSIGN_VERSION
# Basic check to ensure the ARG is provided during build
RUN test -n "${JSIGN_VERSION}" || (echo "Error: JSIGN_VERSION build argument is required." && exit 1)

WORKDIR /build

# Install curl, download the JAR, and clean up apt cache in one layer to reduce size
# Use --no-install-recommends to avoid installing extra packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    echo "Downloading Jsign version ${JSIGN_VERSION}..." && \
    # Use -f to fail fast if download fails, -L to follow redirects
    curl -fL -o jsign.jar "https://github.com/ebourg/jsign/releases/download/${JSIGN_VERSION}/jsign-${JSIGN_VERSION}.jar" && \
    # Clean up downloaded tool and apt cache
    apt-get purge -y --auto-remove curl && \
    rm -rf /var/lib/apt/lists/*

# Run jpackage to create the self-contained application image.
# IMPORTANT: We OMIT --runtime-image here. This tells jpackage to use jlink
# internally to create a *minimal* Java runtime containing only the necessary modules.
# This significantly reduces the final image size compared to bundling the full JDK/JRE.
# The resulting application image will be placed in /app/jsign
RUN jpackage --input /build \
    --name jsign \
    --main-jar jsign.jar \
    --type app-image \
    --dest /app \
    --app-version ${JSIGN_VERSION} \
    --verbose

# Use a minimal base image. Since jpackage bundled a JRE,
# we don't strictly need a Java base, but a minimal base like debian slim
# provides a standard Linux environment.
# You could potentially use an even smaller base like distroless or alpine if
# the jpackage'd app has zero external OS dependencies, but debian-slim is often a safe bet.
FROM debian:stable-slim
# Alternatively, if you face runtime issues, try: FROM eclipse-temurin:21-jre-alpine or FROM eclipse-temurin:21-jre

# Argument needed again for LABEL definition
ARG JSIGN_VERSION

# Add metadata labels (good practice)
LABEL org.opencontainers.image.title="Jsign Application" \
      org.opencontainers.image.version="${JSIGN_VERSION}" \
      org.opencontainers.image.description="Docker image for Jsign code signing tool, packaged with jpackage." \
      org.opencontainers.image.authors="FourCore <team@fourcore.io>"

# Create a non-root user and group for security
RUN groupadd --system --gid 1001 jsigngroup && \
    useradd --system --uid 1001 --gid jsigngroup jsignuser

# Copy *only* the packaged application image from the builder stage
# Ensure the non-root user owns the files
COPY --from=builder --chown=jsignuser:jsigngroup /app/jsign /usr/local/jsign

# Switch to the non-root user
USER jsignuser

# Set the working directory (optional, but good practice if the app expects it)
# WORKDIR /usr/local/jsign

# Set the entrypoint to run the jsign launcher created by jpackage
ENTRYPOINT ["/usr/local/jsign/bin/jsign"]

# Optional: Default command if the entrypoint expects arguments
# CMD ["--help"]