# README

**How to run in Dev mode:**

Install Postgres Client Tools:

```
brew install libpq
```

Create free access token [here](https://fixer.io).

Create .env file in a root:

```
FIXER_IO_ACCESS_KEY=past_access_token_here
```

Run in a first terminal:

```
docker-compose up
```

Run in a second terminal:

```
rvm use
bundle install
rake db:create
rails db:migrate
rails s
```

**How to run in Prod mode:**

You can use an auto config via Dokku or Heroku.

[Dokku](https://github.com/dokku/dokku)