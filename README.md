# Requirements:

* Ruby version: 2.5.1
* Rails version: 5.2.1
* Sidekiq installed and run
* Postgres database

# Run Applicatoin:
From the command line do the following

* `bundle install`
* `bundle exec rake db:create db:schema:load db:migrate db:seed`
* `sidekiq`

To run the test
* `bundle exec rspec`

You could test the API using `Postman` against the following endpoint:

- POST /readings
- GET /readings/:id
- GET /stats/:id

# Database creation
Edit your username and password from `database.yml` file.

