FROM oven/bun:1 as builder

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./packages /app/packages
COPY ./bun.lock /app/bun.lock
COPY ./turbo.json /app/turbo.json

COPY ./apps/websocket /app/apps/websocket

RUN bun install
RUN bun run db:generate

# stage 2

FROM oven/bun:1-slim

WORKDIR /app

COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/packages /app/packages
COPY --from=builder /app/bun.lock /app/bun.lock
COPY --from=builder /app/turbo.json /app/turbo.json

COPY --from=builder /app/apps/websocket /app/apps/websocket

CMD ["bun","run","start:websocket"]