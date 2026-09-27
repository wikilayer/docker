FROM alpine:3.24

ARG TARGETARCH
ARG VERSION

LABEL org.opencontainers.image.source="https://github.com/wikilayer/docker" \
      org.opencontainers.image.version="$VERSION"

RUN apk add --no-cache ca-certificates tzdata \
    && mkdir -p /var/lib/wikilayer/uploads \
    && chown -R 65532:65532 /var/lib/wikilayer

COPY --chown=65532:65532 .build/linux/${TARGETARCH}/wikilayer /usr/local/bin/wikilayer
COPY LICENSE /usr/share/licenses/wikilayer/LICENSE
RUN test "v$(/usr/local/bin/wikilayer version)" = "$VERSION"

USER 65532:65532
ENV STORAGE_DIR=/var/lib/wikilayer/uploads
EXPOSE 8080
VOLUME /var/lib/wikilayer/uploads
ENTRYPOINT ["/usr/local/bin/wikilayer"]
CMD ["serve", "-addr", ":8080", "-single-user"]
