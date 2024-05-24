FROM ghcr.io/atta-1/basedriver:bookworm

ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# disable debian security to ensure that all architectures have the same packages
RUN echo -e "Types: deb\nURIs: http://deb.debian.org/debian\nSuites: bookworm bookworm-updates\nComponents: main\nSigned-By: /usr/share/keyrings/debian-archive-keyring.gpg" > /etc/apt/sources.list.d/debian.sources \
  && apt update \
  && mkdir -p /tmp && cd /tmp \
  && ((export | grep TARGETPLATFORM) || (echo "Missing TARGETPLATFORM" && exit 1)) \
  && ( \
    export ARCH=$(echo $TARGETPLATFORM | cut -d '/' -f2) \
      && curl -O "https://ftp.debian.org/debian/pool/main/c/chromium/chromium-common_125.0.6422.60-1~deb12u1_$ARCH.deb" \
      && curl -O "https://ftp.debian.org/debian/pool/main/c/chromium/chromium_125.0.6422.60-1~deb12u1_$ARCH.deb" \
      && curl -O "https://ftp.debian.org/debian/pool/main/c/chromium/chromium-driver_125.0.6422.60-1~deb12u1_$ARCH.deb" \
      && dpkg -i chromium-common_125.0.6422.60-1~deb12u1_$ARCH.deb || true \
      && dpkg -i chromium_125.0.6422.60-1~deb12u1_$ARCH.deb || true \
      && dpkg -i chromium-driver_125.0.6422.60-1~deb12u1_$ARCH.deb || true \
      && apt install --fix-broken -y \
      && apt clean \
      && rm -rf /var/liexpb/apt/lists/* /tmp/* \
    )

USER webdriver

ENTRYPOINT ["entrypoint", "chromedriver"]

CMD ["--port=4444", "--verbose", "--allowed-origins=*", "--allowed-ips=", "--log-path=/dev/stderr", "--disable-dev-shm-usage"]
EXPOSE 4444