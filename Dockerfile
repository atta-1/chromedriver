#
# Chromedriver Dockerfile
#

FROM ghcr.io/atta-1/basedriver:bookworm

# Install the latest versions of Google Chrome and Chromedriver:
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    chromium \
    chromium-driver \
  && apt-get clean

USER webdriver

ENTRYPOINT ["chromedriver"]

CMD ["--port=4444", "--verbose", "--whitelisted-ips", "--log-path=/dev/stderr", "--disable-dev-shm-usage"]

EXPOSE 4444
