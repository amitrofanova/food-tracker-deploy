# Food Tracker

Full-stack web application for tracking daily nutrition, logging meals, and monitoring calorie intake.

## Features

- User registration and authentication (JWT)
- Food diary — log meals by type (breakfast, lunch, dinner, snack)
- Daily calorie and macronutrient (protein, fat, carbs) summary
- Custom calorie budget per user
- Product search from a shared database
- User-created custom products
- Recipe builder with per-serving nutrition calculation
- Calorie calculator page
- Offline-capable: local data stored in IndexedDB (Dexie) with optional server sync

## Tech Stack

### Client
| Technology | Role |
|---|---|
| Vue 3 (Composition API, `<script setup>`) | UI framework |
| TypeScript | Type safety |
| Pinia | State management |
| Vue Router | Client-side routing |
| TanStack Query | Server state & caching |
| Dexie (IndexedDB) | Local persistence |
| Vite | Build tool |
| FSD (Feature-Sliced Design) | Architecture |

### Server
| Technology | Role |
|---|---|
| Fastify | HTTP server |
| Prisma | ORM |
| PostgreSQL | Database |
| JWT + bcrypt | Authentication |
| Zod | Request validation |

## Project Structure

```
food-tracker-deploy/
├── client/                  # Vue 3 SPA
│   └── src/
│       ├── app/             # App init, router, global styles
│       ├── pages/           # Route-level page components
│       ├── widgets/         # Composite UI blocks (header, meal-block, etc.)
│       ├── features/        # User actions (product-search, create-product, etc.)
│       ├── entities/        # Domain models & UI (user, product, diary-entry, recipe)
│       └── shared/          # Reusable UI, API client, config, styles
├── server/                  # Fastify API
│   ├── src/
│   │   ├── controllers/     # Route handlers
│   │   ├── routes/          # Route definitions
│   │   ├── middleware/      # Auth middleware
│   │   └── lib/             # Prisma client instance
│   └── prisma/
│       ├── schema.prisma    # Data models
│       └── migrations/      # Migration history
├── Dockerfile               # Production multi-stage build (client + server)
├── docker-compose.yml       # Local development (hot reload)
└── docker-compose.prod.yml  # Production local testing (against external DB)
```

## Local Development

Requires [Docker](https://docs.docker.com/get-docker/) and Docker Compose.

```bash
docker compose up --build
```

| Service | URL |
|---|---|
| Client (Vite HMR) | http://localhost:5174 |
| Server (Fastify) | http://localhost:3001 |
| PostgreSQL | localhost:5433 |

Both client and server directories are volume-mounted, so changes are reflected immediately without rebuilding.

## Production Build (local)

Uses a single container: Fastify serves both the API and the built Vue SPA as static files.

```bash
cp .env.example .env  # fill in DATABASE_URL and JWT_SECRET
docker compose -f docker-compose.prod.yml up --build
```

## Deployment (Render.com)

The project is configured for [Render.com](https://render.com) via `render.yaml`.

1. Create a PostgreSQL database on Render (or use [Neon.tech](https://neon.tech))
2. Create a Web Service pointing to this repository
3. Set the following environment variables in the Render dashboard:

| Variable | Description |
|---|---|
| `DATABASE_URL` | PostgreSQL connection string |
| `JWT_SECRET` | Secret key for signing JWT tokens |

Migrations are applied automatically on each deploy via the release command:
```
npx prisma migrate deploy
```

## Environment Variables

### Server
| Variable | Default (dev) | Description |
|---|---|---|
| `DATABASE_URL` | `postgresql://postgres:postgres@postgres:5432/food_tracker` | PostgreSQL connection string |
| `JWT_SECRET` | `dev_jwt_secret_change_in_production` | JWT signing secret |
| `NODE_ENV` | `development` | Environment |
| `PORT` | `3001` | Server port |

### Client
| Variable | Default (dev) | Description |
|---|---|---|
| `VITE_API_BASE_URL` | `http://localhost:3001` | Base URL for API requests |
