FROM ruby:3.0.4

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY . .

RUN rake assets:precompile
RUN rails db:migrate

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

