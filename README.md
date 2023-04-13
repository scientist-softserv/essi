# ESS Images

[![CircleCI](https://circleci.com/gh/IU-Libraries-Joint-Development/essi.svg?style=svg)](https://circleci.com/gh/IU-Libraries-Joint-Development/essi)

A [Samvera](https://samvera.org/) [Hyrax](https://github.com/samvera/hyrax) based image cataloging application.

Features a [IIIF](https://iiif.io/) manifest structure editor,
bulk import using [Bulkrax](https://github.com/samvera-labs/bulkrax), and flexible metadata using [Allinson Flex](https://github.com/samvera-labs/allinson_flex). 

## Docker Development

To set up a development environment via Docker Compose:

1. Check that `docker` and `docker-compose` commands are installed and functional
1. Clone this git repo
1. `cd` into the `essi` directory
1. In the `.env` file, set USER_ID and GROUP_ID to match your user. Determine using `id -u` and `id -g` respectively.
1. Generate self-signed SSL certificate.
   - For example: `openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout ./tmp/certs/localhost.key -out ./tmp/certs/localhost.crt`
   - The key file may need read permissions for group 101 (the nginx container user's group)
1. Run `docker-compose build`
1. Add your IU credentials to .env as IU_EMAIL and IU_PASSWORD.
1. Run `docker-compose up`
1. Check that all services are "Up" using `docker-compose ps` from the `essi` directory
   - If there is a missing `.env.development` error, add an empty `.env.development` file and re-run `docker-compose up`
1. Load the application at https://localhost:3000
   - Other services (Fedora, Solr, etc) are also available. Check `docker-compose ps` for port numbers.
1. To access a shell in the essi service: `docker-compose exec essi bash`
   - You could then `bundle exec rails c` to access the Rails console.
     - If you have logged in to the site, this will make that user an admin: `User.first.roles << Role.find_or_create_by(name: 'admin')`

To **DELETE** the docker-compose data volumes and restart with a clean slate: From the `essi` directory: `docker-compose down -v`

## SPECS:
1. Jasmine - Can run from terminal or by adding /specs path onto the base url (ex: <https://localhost:3000/specs>).
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


#### New developer guide for set up local instance (on Mac)
1. Follow Hyrax's [basic prerequisites](https://github.com/samvera/hyrax#prerequisites), make sure _everything_ is running.

2. besides Hyrax's [basic prerequisites](https://github.com/samvera/hyrax#prerequisites), install yarn

3. Go to Github repo, fork your master branch

4. in your local terminal :
  * git clone https://github.com/IU-Libraries-Joint-Development/essi.git
  * cd essi

    * bundle install
    * bundle exec rake db:migrate
    * bundle exec rake hyrax:default_collection_types:create
    * bundle exec rake hyrax:workflow:load
    * bundle exec rake hyrax:default_admin_set:create

  * In rails console, type following to create admin user for yourself:
    * User.find_by_email('username@iu.edu').roles<<Role.find_or_create_by(name:'admin')

 5. Run following in seperate terminal windows 
  * brew services start redis (_or make sure redis server is running in background_):
  * solr_wrapper (go to http://127.0.0.1:8983/solr/#/, click core-selector in left menu, you will see hydra-development in the dropdown list) 
    * If you couldn't find hydra-development in the core-selector, you may need check your .solr_wrapper file in the project directory, make sure there is no extra space on the front of the line.
  * fcrepo_wrapper (check http://127.0.0.1:8984/ if fedora is running)
  * bundle exec rails s (ESSI is running on http://localhost:3000/)
  * Now, you can go to the ESSI website and try to upload images. If the image is not shown, instead, there is an error like: "Routing Error, No route matches [GET] /uv/uv.html", then, run yarn to install the universal viewer javascript libraries. 
  
