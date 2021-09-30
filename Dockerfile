FROM ruby:2.7.4

# Install packages
RUN apt-get update && apt-get install -y build-essential nodejs libpq-dev

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

# Run application by default
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
