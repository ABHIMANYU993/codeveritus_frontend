# Stage 1: Build
FROM node:18-alpine AS build

# declare build time variable for Docker
ARG REACT_APP_API_URL

# declare environment variable for React
ENV REACT_APP_API_URL=$REACT_APP_API_URL


WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build


# Stage 2: Serve with Node 
FROM node:18-alpine AS prod
WORKDIR /app
RUN npm install -g http-server
COPY --from=build /app/build ./build
# Do NOT copy certs here!
EXPOSE 3000
CMD ["http-server", "build", "-p", "3000", "-S", "-C", "/etc/ssl/certs/origin.pem", "-K", "/etc/ssl/private/origin.key"]


# # Stage 1: Build
# FROM node:20-alpine AS builder
#
# # declare build time variable for Docker
# ARG REACT_APP_API_URL
#
# # declare environment variable for React
# ENV REACT_APP_API_URL=$REACT_APP_API_URL
#
# WORKDIR /app
# COPY package.json .
# RUN npm install
# COPY . .
# RUN npm run build
#
# # Stage 2: Serve with Nginx
# FROM nginx:alpine
# COPY --from=builder /app/build /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
