# ---- Stage 1: Build Vue client ----
FROM node:22-alpine AS client-builder

WORKDIR /client

# VITE_API_BASE_URL is empty because client and API share the same origin.
# Pass a build arg only if you need to override (e.g. for a CDN).
ARG VITE_API_BASE_URL=""
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL

COPY client/package*.json ./
RUN npm ci

COPY client/ .
RUN npm run build

# ---- Stage 2: Build server ----
FROM node:22-alpine AS server-builder

WORKDIR /server

COPY server/package*.json ./
RUN npm ci

COPY server/ .
RUN npm run build

# ---- Stage 3: Production runtime ----
FROM node:22-alpine

WORKDIR /app

COPY server/package*.json ./
RUN npm ci --omit=dev

# Compiled server
COPY --from=server-builder /server/dist ./dist

# Built Vue SPA — Fastify serves this as static files
COPY --from=client-builder /client/dist ./public

# Prisma schema and migrations
COPY server/prisma ./prisma
COPY server/prisma.config.ts ./prisma.config.ts

EXPOSE 3001

# Run pending migrations, then start the server.
# On Render.com you can use the "Release Command" for migrations instead:
#   npx prisma migrate deploy
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/server.js"]
