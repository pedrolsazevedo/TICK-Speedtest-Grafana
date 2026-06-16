FROM telegraf:1.38

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg apt-transport-https && \
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt-get install -y --no-install-recommends speedtest && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Accept the Speedtest EULA and GDPR at build time (fixes GitHub issue #6)
RUN mkdir -p /root/.config/ookla && \
    echo '{"Settings": {"LicenseAccepted": "677a702ab89984b0b555cc5a31d258c0031584221ef4f293e62c5280a518a8c0", "GDPRConsent": "677a702ab89984b0b555cc5a31d258c0031584221ef4f293e62c5280a518a8c0"}}' \
    > /root/.config/ookla/speedtest-cli.json
