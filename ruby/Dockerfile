FROM ruby:3.4-slim
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock ./
COPY vendor/gems vendor/gems
RUN gem install bundler:2.3.26 && bundle config set --local without "development test" && bundle install
COPY . .
EXPOSE 9292
CMD ["bundle", "exec", "puma", "-p", "9292", "config.ru"]
