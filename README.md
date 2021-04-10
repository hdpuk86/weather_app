# Weather App

## Setting up

Ruby Version: 2.5.7

Rails Version: 6.1.3.1

---

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
