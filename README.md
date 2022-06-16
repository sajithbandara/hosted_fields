# Ruby on Rails – Hosted Fields

## Setup and Installation Instructions

Note: This project is run on Rails 7

1. Install bundler

```sh
gem install bundler
```

2. Run bundle to install dependencies

```sh
bundle install
``` 

3. Using example.env, copy the contents into a local .env file where you will input your API credentials.

4. Start the application

```sh
rails s
```

5. Navigate to ```localhost:3000```

Test amounts and values can be located at 
https://developer.paypal.com/braintree/docs/reference/general/testing

6. To view a 3 month history page of your transactions, you can navigate to:

```sh
localhost:3000/checkouts
```

Note: Please allow time for the page to load especially if you have a large number of sandbox transactions.
