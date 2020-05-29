# system dependency image
FROM ruby:2.5-stretch AS essi-sys-deps

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} essi && \
    useradd -m -l -g essi -u ${USER_ID} essi && \
    apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" | tee -a /etc/apt/sources.list && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential default-jre-headless libpq-dev nodejs \
      libreoffice-writer libreoffice-impress imagemagick unzip ghostscript && \
    apt-get install -y libtesseract-dev libleptonica-dev liblept5 tesseract-ocr -t testing \
    yarn && \
    rm -rf /var/lib/apt/lists/*
RUN yarn && \
    yarn config set no-progress && \
    yarn config set silent
RUN mkdir -p /opt/fits && \
    curl -fSL -o /opt/fits/fits-1.5.0.zip https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip && \
    cd /opt/fits && unzip fits-1.5.0.zip && chmod +X fits.sh
ENV PATH /opt/fits:$PATH

###
# ruby dev image
FROM essi-sys-deps AS essi-dev

RUN mkdir /app && chown essi:essi /app && mkdir -p /run/secrets
WORKDIR /app

USER essi:essi
COPY --chown=essi:essi Gemfile Gemfile.lock ./
#TODO: N8 specific - add bulkrax for development; remove for PR back to ESSI
#COPY --chown=essi:essi vendor/engines/bulkrax /app/vendor/engines/bulkrax

RUN gem update bundler
RUN bundle install -j 2 --retry=3

COPY --chown=essi:essi . .

ENV RAILS_LOG_TO_STDOUT true

###
# ruby dependencies image
FROM essi-sys-deps AS essi-deps

RUN mkdir /app && chown essi:essi /app
WORKDIR /app

USER essi:essi

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY --chown=essi:essi Gemfile Gemfile.lock ./
RUN gem update bundler && \
    bundle install -j 2 --retry=3 --deployment --without development

COPY --chown=essi:essi . .

ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_ENV production

ENTRYPOINT ["bundle", "exec"]

###
# sidekiq image
FROM essi-deps as essi-sidekiq
USER essi:essi
ARG SOURCE_COMMIT
ENV SOURCE_COMMIT $SOURCE_COMMIT
CMD sidekiq

###
# webserver image
FROM essi-deps as essi-web
USER essi:essi
RUN bundle exec rake assets:precompile
EXPOSE 3000
ARG SOURCE_COMMIT
ENV SOURCE_COMMIT $SOURCE_COMMIT
CMD puma -b tcp://0.0.0.0:3000
