# README
Running on:
* **Ruby 3.2.2**
* **Ruby On Rails 7.0.8**
* **MySQL 8.1.0**
## Installation
**Execute bundle**
```
bundle install
```
**Run migrations**
```
rake db:migrate
```
## Commands
_Fills the 2d matrix megaverse with polyanets, comeths and soloons gathered from api entry point goals_
```
rake crossmint:fill_megaverse
```
_Cleans the 2d matrix megaverse from api._
```
rake crossmint:clean_megaverse
```
**NOTE: This command does not remove records from database.**