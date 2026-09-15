FROM hexpm/elixir:1.14.5-erlang-25.3.2.8-debian-bullseye-20230612-slim AS build
WORKDIR /app
ENV MIX_ENV=prod
RUN mix local.hex --force && mix local.rebar --force
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod && mix deps.compile
COPY config config
COPY lib lib
RUN mix release

FROM debian:bullseye-20230612-slim
RUN apt-get update && apt-get install -y --no-install-recommends libstdc++6 openssl libncurses5 locales ca-certificates \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app/_build/prod/rel/dispatch ./
CMD ["bin/dispatch", "start"]
