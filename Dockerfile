FROM jekyll/builder:4.2.0 as build

# Install Ruby 3.x and upgrade Bundler
RUN apk update && apk add --no-cache zip ruby=2.7.1-r0 ruby-dev build-base \
    && gem install bundler:2.2.33

WORKDIR /tmp
COPY . /tmp

RUN addgroup oss && adduser -D -G oss oss && chown -R oss:oss .
RUN chown -R oss:oss /usr/gem
USER oss
RUN bundle install
RUN npm install
RUN ./node_modules/gulp/bin/gulp.js build
RUN jekyll build

FROM nginx:alpine
COPY --from=build /tmp/_site /usr/share/nginx/html
