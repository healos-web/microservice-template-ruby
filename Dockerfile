FROM ruby:3.1.1-slim-bullseye AS base

RUN apt-get update -y && \
    apt-get install libpq-dev -y

###################################

FROM base AS dependencies

RUN apt-get install build-essential -y

COPY Gemfile Gemfile.lock ./

RUN bundle config set without "development test" && \
    bundle install --jobs=3 --retry=3

###################################

FROM base

RUN adduser app --disabled-password

WORKDIR /home/examplesvc

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

COPY --chown=app . ./
RUN rm -rf ./spec
RUN rm -f .rspec
RUN rm -f .rubocop.yml
COPY --from=dependencies Gemfile Gemfile.lock ./

CMD ["bundle", "exec", "karafka", "s"]
