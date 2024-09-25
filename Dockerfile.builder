FROM jekyll/builder:4.2.0 as build

# Install zip, ruby 3.3.5, and upgrade Bundler
RUN apk update && apk add --no-cache zip ruby=3.3.5-r0 ruby-dev build-base \
    && gem install bundler:2.5.16


WORKDIR /usr/local/site
COPY Gemfile /usr/local/site
COPY Gemfile.lock /usr/local/site
COPY package.json /usr/local/site
COPY package-lock.json /usr/local/site

RUN addgroup oss && adduser -D -G oss oss && chown -R oss:oss .
RUN chown -R oss:oss /usr/gem

# This may not be necessary, but local runs do not have these folders
# RUN mkdir -p /github/workflow
# RUN chown -R oss:oss /github
# RUN chmod -R 777 /github

USER oss

#RUN bundle config set deployment true
RUN bundle install
RUN npm install

# Build the site
#RUN ./node_modules/gulp/bin/gulp.js build
#RUN jekyll build

# Prepare to deploy static site
#WORKDIR /usr/local/site/_site
#RUN tar -cvf site.tar.gz .
