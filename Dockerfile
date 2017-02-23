# Inherit from Heroku's stack
FROM heroku/cedar:14
MAINTAINER Josiah Berkebile <praenato14@gmail.com>

RUN apt update -y

RUN apt install -y git zsh vim nano sudo libpq-dev postgresql-client-9.6 --fix-missing

# Internally, we arbitrarily use port 8000
ENV PORT 8000
# Which version of node?
ENV NODE_ENGINE 6.9.4
# Locate our binaries
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:$PATH

# Create some needed directories
RUN mkdir -p /app/heroku/node /app/.profile.d
WORKDIR /app/user

# Install node
RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node

# Export the node path in .profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh

# Add development user
RUN useradd -ms /bin/zsh user
RUN usermod -aG sudo user
RUN echo 'user:user' | chpasswd
USER user

# Create environment vars for user, 'user', as well.
ENV PORT 8000
ENV NODE_ENGINE 6.9.4
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:$PATH

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN echo PATH=$PATH | tee -a ~/.bashrc ~/.zshrc

USER root
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

EXPOSE 8000

USER user
