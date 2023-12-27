# README

This repo is designed to showcase the code written for a french article about API following jsonapi.org spec, written for the ruby-biscuit newsletter.

* [Part 1](https://www.rubybiscuit.fr/p/lapi-la-plus-parfaite)
* Part 2 - to be published

## Install

* Build the docker images
  * `docker-compose build`
* Then create and seed the db
  * `docker-compose run web rails db:create`
  * `docker-compose run web rails db:seed`
* And run it
  * `docker-compose up`
