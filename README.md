# KaamSetu

KaamSetu is a mobile-first Next.js application for connecting households with local daily-wage workers.

## Run locally

1. Install Node.js 20+ and PostgreSQL 16+.
2. Create a PostgreSQL database called `kaamsetu`.
3. Copy `.env.example` to `.env.local` and set your own PostgreSQL password.
4. Run `drizzle/0000_initial_schema.sql`, then `drizzle/0001_backend_integrity.sql` against that database.
5. Run `pnpm install` followed by `pnpm dev`, then open `http://localhost:3000`.

The demo uses OTP `123456`. Demo records are created automatically on first launch.

## Sharing safety

This project intentionally excludes `.env.local`, database dumps, `node_modules`, and build output. Never share database passwords or production connection strings.
