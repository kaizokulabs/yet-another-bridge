FROM node:18-alpine AS base

FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json yarn.lock* ./
RUN yarn --frozen-lockfile

# not for production
FROM base AS runner
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules

CMD ["yarn", "run", "dev", "-H", "0.0.0.0"]
