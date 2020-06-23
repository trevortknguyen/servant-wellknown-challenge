FROM debian:buster-slim
WORKDIR /app
COPY ./bin/servant-wellknown-challenge /app
CMD /app/servant-wellknown-challenge