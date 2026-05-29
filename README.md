# Food Tracker

🇬🇧 English | [🇷🇺 Русский](README.ru.md)

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

| Technology                                | Role                       |
| ----------------------------------------- | -------------------------- |
| Vue 3 (Composition API, `<script setup>`) | UI framework               |
| TypeScript                                | Type safety                |
| Pinia                                     | State management           |
| Vue Router                                | Client-side routing        |
| TanStack Query                            | Server state & caching     |
| Dexie (IndexedDB)                         | Local persistence          |
| Vite                                      | Build tool                 |
| Capacitor                                 | Native Android/iOS wrapper |
| FSD (Feature-Sliced Design)               | Architecture               |

### Server

| Technology   | Role               |
| ------------ | ------------------ |
| Fastify      | HTTP server        |
| Prisma       | ORM                |
| PostgreSQL   | Database           |
| JWT + bcrypt | Authentication     |
| Zod          | Request validation |

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

## Deployment (Render.com)

The project is configured for [Render.com](https://render.com) via `render.yaml`.

## Mobile App (Android)

The client is wrapped with [Capacitor](https://capacitorjs.com) to produce a native Android APK.

[⬇ Download APK](#) _(link coming soon)_
