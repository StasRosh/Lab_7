# Etap 1: Budowanie aplikacji dla architektury amd64
FROM node:alpine AS build-amd64
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Etap 2: Budowanie aplikacji dla architektury arm64
FROM node:alpine AS build-arm64
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Etap 3: Tworzenie obrazu docelowego dla amd64
FROM nginx:latest AS final-amd64
COPY --from=build-amd64 /app/build /usr/share/nginx/html

# Etap 4: Tworzenie obrazu docelowego dla arm64
FROM nginx:latest AS final-arm64
COPY --from=build-arm64 /app/build /usr/share/nginx/html