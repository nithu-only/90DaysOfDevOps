FROM node:18.18-alpine3.18

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY package*.json ./
RUN apt update && apt install -y curl
RUN npm install --production

COPY . .

USER appuser

CMD ["node", "index.js"]