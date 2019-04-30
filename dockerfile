FROM node:12-alpine as node_base

#Create the base image for my app
FROM node_base as app_base
WORKDIR /usr/app
COPY package.json ./
# Install app dependencies only
RUN yarn install --prod 

# Build the application
FROM node_base as build
WORKDIR /usr/src/app
COPY . .
RUN yarn install && yarn build

# Create the application container 
FROM app_base as app
WORKDIR /usr/app
COPY index.js .
COPY --from=build /usr/src/app/dist ./public

ENV NODE_ENV=production

EXPOSE 8080
CMD ["node","."]