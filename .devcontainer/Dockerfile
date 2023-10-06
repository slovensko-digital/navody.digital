# Start with base vscode image and install ruby and rails into it
FROM mcr.microsoft.com/vscode/devcontainers/base:bullseye

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm

RUN npm install -g yarn

# Install Postgresql 12
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
RUN apt update
RUN apt install -y postgresql-12 postgresql-client-12

# Install chromium-driver
RUN apt install -y chromium-driver

# Install ruby (compiling takes some time)
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 3.2.1"

# Install Rails
RUN ln -s /bin/mkdir /usr/bin/mkdir
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && gem install rails webdrivers"
RUN chown -R vscode /usr/local/rvm

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains 
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"
