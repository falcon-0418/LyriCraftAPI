# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.2.2

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# heroku apps:destroy -a lyricraft-api
# heroku create lyricraft-api
# heroku git:remote -a lyricraft-api
# heroku buildpacks:add https://github.com/falcon-0418/heroku-buildpack-mecab-ipadic-neologd.git
# heroku config:set LD_LIBRARY_PATH=/app/.heroku/mecab/lib
# heroku config:set MECAB_PATH=/app/.heroku/mecab/lib
# heroku repo:purge_cache -a lyricraft-api
