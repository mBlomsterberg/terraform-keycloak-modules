# ── Build stage — pre-optimise Keycloak for the chosen runtime configuration ───
FROM quay.io/keycloak/keycloak:26.6.2 AS builder

COPY --chown=keycloak:keycloak providers/ /opt/keycloak/providers/
COPY --chown=keycloak:keycloak themes/ /opt/keycloak/themes/

RUN /opt/keycloak/bin/kc.sh build \
    --db=postgres \
    --health-enabled=true \
    --metrics-enabled=true \
    --feature=http-optimized-serialization,scim-api

# ── Runtime stage ──────────────────────────────────────────────────────────────
FROM quay.io/keycloak/keycloak:26.6.2

COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY --from=docker.io/curlimages/curl:latest /usr/bin/curl /usr/bin/curl

# 8080  — HTTP (browser + Terraform provider)
# 9000  — management (health, metrics)
EXPOSE 8080
EXPOSE 9000

HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=6 \
  CMD curl -sf http://localhost:9000/health/ready || exit 1

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
