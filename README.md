# Weather App

The app should open on a page with 2 links:

'Manage heat ratings' - This takes you to an index where you can view & edit the heat limits.

'Get a forecast' - where you can lookup a forecast using a UK postcode.

After creating a forecast the app will redirect you back to the home page and you should see your forecasts.

## Setting up

Ruby Version: 2.5.7

Rails Version: 6.1.3.1

---

Clone:
```
git clone git@github.com:hdpuk86/weather_app.git
cd weather_app
```

Create a .env file and add the API Key
```
touch .env
echo 'WEATHER_API_KEY="key"' >> .env
```

Install Ruby gems:
```
bundle install
```

Install Javascript packages:
```
yarn install
```

Create & migrate the database:
```
rails db:create db:migrate
```

Run the seeds:
```
rails db:seed
```

Start server, application should run on `localhost:3000`:
```
rails server
```

## Running tests with MiniTest

```
# Run all tests
rails test

# Run a specific test file:
rails test test/controllers/foo_controller_test.rb

# Run a specific test:
rails test test/controllers/foo_controller_test.rb:4
```

---
