# * The Build environment
FROM node:14.18.1-buster as build

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
RUN npm install react-scripts@3.4.1 -g 

# add app
COPY . ./
# build prod code
RUN npm run build

# * The Production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

# Allows for React router to used with nginx
# COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 1337:80
CMD ["nginx", "-g", "daemon off;"]