FROM ruby:2.5.1-alpine3.7
WORKDIR /app

RUN apk add --no-cache libpq tzdata nodejs

COPY Gemfile Gemfile.lock ./

RUN apk add --no-cache --virtual .build-deps make gcc libc-dev postgresql-dev && \
  bundle install \
  && apk del .build-deps

COPY . .

CMD ["bin/rails", "server"]
