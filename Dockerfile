FROM ruby:2.7.4

# Install packages
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
RUN mkdir /app
WORKDIR /app

# Bundle and cache Ruby gems
COPY Gemfile* ./
RUN bundle config set deployment true
RUN bundle config set without development:test
RUN bundle install

# Cache everything
COPY . .


ENV RAILS_ENV=${RAILS_ENV}
RUN bundle exec rails assets:precompile

# Run application by default
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
