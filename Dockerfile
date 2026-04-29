# ---- Stage 1: Build Vue client ----
FROM node:22-alpine AS client-builder

RUN apk add --no-cache git

WORKDIR /client

RUN git clone https://github.com/amitrofanova/food-tracker-client.git .

# Use yarn because the client project uses yarn
RUN yarn install
RUN yarn build

# ---- Stage 2: Build server ----
FROM node:22-alpine AS server-builder

RUN apk add --no-cache git

WORKDIR /server

RUN git clone https://github.com/amitrofanova/food-tracker-server.git .

RUN npm install
# Generates Prisma client into src/generated/prisma, then compiles TypeScript to dist/
RUN npm run build

# ---- Stage 3: Production runtime ----
FROM node:22-alpine

WORKDIR /app

COPY --from=server-builder /server/package*.json ./
RUN npm install --omit=dev

# Compiled server
COPY --from=server-builder /server/dist ./dist

# Built Vue SPA — Fastify serves this as static files
COPY --from=client-builder /client/dist ./public

# Prisma schema and migrations (needed for `prisma migrate deploy`)
COPY --from=server-builder /server/prisma ./prisma

EXPOSE 3001

# Run pending migrations, then start the server.
# On Render.com you can instead set the Release Command: npx prisma migrate deploy
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/server.js"]
