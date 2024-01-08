#https://www.knowledgehut.com/blog/web-development/how-to-dockerize-react-app
FROM node:16-alpine AS builder
ENV NODE_ENV production

# Add a work directory
WORKDIR /app

# Cache and Install dependencies
COPY package.json .
COPY yarn.lock .
RUN yarn install

# Copy app files
COPY . .

# Build the app
RUN yarn build

# Bundle static assets with nginx
FROM nginx:1.21.0-alpine as production
ENV NODE_ENV production

# Copy built assets from builder
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

COPY --from=builder /app/build .

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]