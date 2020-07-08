# ESS Images [![CircleCI](https://circleci.com/gh/IU-Libraries-Joint-Development/essi.svg?style=svg)](https://circleci.com/gh/IU-Libraries-Joint-Development/essi)

A Samvera Hyrax based image cataloging application.

To set up a development environment via Docker:

1. Pull down the Github repo
1. cd into the directory
1. In the `.env` file, set USER_ID and GROUP_ID to match your user. Determine using `id -u` and `id -g` respectively.
1. Run `docker-compose up web`. If there is a missing `.env.development` error, add an empty `.env.development` file and re-run `docker-compose up web`
1. Load the application at `http://localhost` or `http://essi.docker` (if you are using Dory)

If using Dory: [Dory](https://github.com/FreedomBen/dory)

## SPECS:
1. Jasmine - Can run from terminal or by adding /specs path onto the base url (ex: <http://localhost:3000/specs>).
1. RSPEC - May need to run `sc exec -s solr 'solr-precreate hydra-test /opt/config'`

## Hyrax Setup
For a Hyrax specific guide and setup, please refer to the Hyrax Development Guide at https://github.com/samvera/hyrax/wiki/Hyrax-Development-Guide

### FEATURE SPECS:
**Optional: 

If using a Mac, it is possible to watch the feature specs run through the browser by removing the headless flag in spec/support/capybara.rb, and connecting the Screen Sharing application to your IP address and port 5959. Please note, the server must be running. 


#### Deployment to a local development environment

When building and deploying to a local developer's machine, the copy and ignore rules allow the `db/development.sqlite3` file, which is the default database file if no further configuration changes are made, to be copied in from the local directory into the running container.  This gets around the issue of not having a properly migrated database in place when the Rails app starts.  One benefit of including the developer's database file in the build is that the running Rails app in the container will be identical to the when it is running as a local Rails app because the database will be the same and presumably be pointed to the same Fedora/Solr.

git clone (cd to cloned directory)

bundle exec rake db:migrate

In separate windows, provide Fedora/Solr for the container:

solr_wrapper
fcrepo_wrapper
Once Fedora/Solr are running, create the AdminSet in the local app directory:
bundle exec rails hyrax:default_admin_set:create
Now build and run:
docker build --tag=essi .
docker run --net="host" -p 3000:3000 essi
Notes:

A local instance of Redis should also be running on the host machine.
If using Docker for Mac, all localhost and 127.0.0.1 references should be replaced with host.docker.internal in config/essi_config.example.yml.
