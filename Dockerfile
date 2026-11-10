FROM ruby:4.0.9

# Install packages: build tools, postgres client libs, Node.js 22 and yarn
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
  && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get install -qq --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    nodejs \
  && npm install -g yarn@1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
RUN mkdir /app
WORKDIR /app

# Bundle and cache Ruby gems
COPY Gemfile* ./
RUN bundle config set frozen true
RUN bundle config set without "development test"
RUN bundle install

# Cache everything
COPY . .

RUN yarn install --frozen-lockfile
RUN SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production bundle exec rails assets:precompile

# Run application by default
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
