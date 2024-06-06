FROM ghcr.io/cirruslabs/flutter:3.22.1 AS build

RUN mkdir /app/
COPY . /app/
WORKDIR /app/

RUN flutter doctor -v

RUN flutter config --enable-web

ENV API_BASE_URL=localhost
ENV ENVIRONMENT=prod
ENV SENTRY_DSN=""

RUN flutter build web --release --web-renderer=auto -t lib/main.dart --dart-define=API_BASE_URL=$API_BASE_URL --dart-define=ENVIRONMENT=$ENVIRONMENT --dart-define=SENTRY_DSN=$SENTRY_DSN

# once here the app will be compiled and ready to deploy

# use nginx to deploy
FROM nginx:1.25.2-alpine

# Copy config nginx
COPY --from=build /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# copy the info of the builded web app to nginx
COPY --from=build /app/build/web .

CMD ["nginx", "-g", "daemon off;"]