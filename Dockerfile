# ============================================================
# Production Dockerfile — AstroWind on Cloud Run
# Multi-stage: Node 22 (build) → nginx 1.27-alpine (serve)
# Final image: ~25MB, non-root, health-checked
# ============================================================

# === Stage 1: Install dependencies ===
FROM node:26-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts && npm rebuild sharp

# === Stage 2: Build static site ===
FROM node:26-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# === Stage 3: Production runtime ===
FROM nginx:1.31-alpine AS production

# Remove default config
RUN rm -rf /etc/nginx/conf.d/default.conf

# Create non-root user
RUN addgroup -g 1001 -S appgroup \
    && adduser -u 1001 -S appuser -G appgroup \
    && chown -R appuser:appgroup /var/cache/nginx /var/log/nginx /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown appuser:appgroup /var/run/nginx.pid

# Copy nginx config and built assets
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build --chown=appuser:appgroup /app/dist /usr/share/nginx/html

# Run as non-root
USER appuser

# Cloud Run expects port 8080
EXPOSE 8080

# Health check for Cloud Run
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1
