# DealFinder Sinatra App

A lightweight Sinatra-based application that allows users to search for local deals by price, category, location, and tags. Deals are loaded from a static JSON file (`deals.json`).

[UI API Docs (Swagger)](https://yurazinko.github.io/deal_finder_sinatra)

# How to run the application
Install gems:
```bash
$ bundle install
```

Start the server:
```bash
$ ruby app.rb
```

The application will be available under this address: [http://localhost:4567/deals/search](http://localhost:4567/deals/search)

# How to run unit tests

Just run:
```bash
$ rspec
```