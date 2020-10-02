# README

How to run in Dev mode:

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