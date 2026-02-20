FROM ruby:3.1-slim
RUN apt-get update \
  && apt-get install -y default-libmysqlclient-dev build-essential libssl-dev \
  && rm -rf /var/lib/apt/lists/*
RUN gem install 'mongify:1.4.1' 'mysql2:~>0.5' --no-document
WORKDIR /work
COPY . /work
ENTRYPOINT ["sleep","infinity"]
