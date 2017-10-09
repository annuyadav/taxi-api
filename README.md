# Taxi API app
You are the proprietor of füber, an on call taxi service.
You have a fleet of cabs at your disposal, and each cab has a location, determined by it’s latitude and longitude.
A customer can call one of your taxis by providing their location, and you must assign the nearest taxi to the customer.
Some customers are particular that they only ride around in pink cars, for hipster reasons. You must support this ability.
When the cab is assigned to the customer, it can no longer pick up any other customers
If there are no taxis available, you reject the customer's request.
The customer ends the ride at some location. The cab waits around outside the customer’s house, and is available to be assigned to another customer.

## Getting Started
Try the following steps to run the app.

### Prerequisites
Assuming you have installed `git`, `ruby` and `rvm`.

## Installing and Running the program

To start the program clone the repo.

```
git clone git@github.com:annuyadav/taxi-api.git
```

Go to directory art_gallery
```
cd taxi-api
```

and exucute
```
gem install bundler
bundle install
```

Then create and migrate database:
```
rake db:create db:migrate
```

then start the server:
```
rails s
```

to run test cases
```
bundle exec rspec
```


## API Endpoints

Our API will expose the following RESTful endpoints.

| Endpoint | Functionality |
| --- | --- |
| GET /taxis | List all taxis |
| POST /journey | Create a new journey with given params (parameters are latitude, longitude, color ) example: post /journey, params: {journey: {latitude: '332.11', longitude: '44.99', color: 'pink'}|
| PUT /journey/:id/start | Start the jouney with provided id |
| PUT /journey/:id/end | End the jouney with provided id and parameters which are latitude and longitude. example: put /journey/:id/end, params: {journey: {latitude: '332.11', longitude: '44.99'} |
| GET /journey/:id/payment_amount | Get payment details of journey with provided id|


#### Things which can be included:
authorizing all API requests making sure that all requests have a valid token and user payload.