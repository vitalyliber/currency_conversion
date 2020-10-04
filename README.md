# README

How to run in Dev mode:

Create free access token [here](https://fixer.io).

Create .env file in a root:

```
FIXER_IO_ACCESS_KEY=past_access_token_here
```

First terminal:

```
docker-compose up
```

Second terminal:

```
rvm use
bundle install
rake db:create
rails db:migrate
rails s
```