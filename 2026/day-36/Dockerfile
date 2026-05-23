# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY app/package*.json ./

RUN npm install

COPY app .

# ---------- Stage 2: Production ----------
FROM node:20-alpine

WORKDIR /app

# create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app .

USER appuser

EXPOSE 3000

CMD ["node", "index.js"]