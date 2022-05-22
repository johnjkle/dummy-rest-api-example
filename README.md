# Dummy REST API example - Simple Ruby-based automation framework

## Setup/Installation

The framework uses Ruby 2.7.3 (should support > 2.7.x as well but may have some incompatibilities with Ruby 3.x.x) and the Faraday HTTP client to test a simple REST example API at 'https://dummy.restapiexample.com'. The test framework uses the Rspec framework and the Faker gem to generate randomized data when needed.

With Ruby installed, the only gem that has to be installed manually is the Bundler gem, which will then be used to install all other gems/dependencies:

```
gem install bundler
```

Once Bundler is installed, we can use it to install all other required gems (defined in the Gemfile) - in the project root folder (Gemfile will be in this path):

```
bundle install
```

Once all dependencies have been installed, the tests can be executed. If an individual gem installation fails for any reason, it can be installed "manually" instead, e.g:

```
gem install faraday
```

## Running Tests

Once again, from the project root folder, all tests can be executed by simply running:

```
rspec spec
```

This attempts to run any spec file (Rspec's terminology for individual test cases) under the spec folder. Subfolders or individual spec file paths could be passed as well if required:

```
rspec spec/api/dummy_rest_api_spec.rb
```

Since this project only currently contains a single spec, the above statements are functionally equivalent.

Once tests have executed, a summary is output to the terminal, for example:

```
Finished in 5.23 seconds (files took 2.14 seconds to load)
5 examples, 0 failures
```

## Implementation Notes/Considerations/Caveats

The spec file in this project contains 5 test cases, which test the CRUD operations of the following endpoints:

```
https://dummy.restapiexample.com/api/v1/employees
https://dummy.restapiexample.com/api/v1/employee/{id}
https://dummy.restapiexample.com/api/v1/create
https://dummy.restapiexample.com/api/v1/update/{id}
https://dummy.restapiexample.com/api/v1/delete/{id}
```

In an ideal test run, these tests can typically complete successfully in ~ 5 seconds. However, the API at 'https://dummy.restapiexample.com/api' is _severely_ rate limited and is very likely to return an HTTP 429 error, requiring the next request to be executed ~ 45 seconds later. To cater for this, without waiting any longer than required, our Faraday HTTP client is set up to retry 2 additional times on a 429 error, with a wait time of 45 seconds between requests. This is defined in spec_helper.rb, when instantiating our Faraday client:

```
faraday.request :retry, max: 2, interval: 45, retry_statuses: [429]
```

It should be noted that any retry will add an additional 45 seconds to the overall execution but the test case should pass if the error is not encountered 3 times in a row.

Additionally, the default behaviour of Faraday does not return too much information while tests are executing, so a "verbose" logger is set up in helpers/faraday.rb to return additional information such as the endpoint under test, status (only if != 200) and response body/response (in the case of a 429 for example), so that it's easier to follow the test execution in the terminal.

The dummy API requests are instantiated in helpers/dummy_rest_api.rb, removing the requests themselves from the actual test cases/spec. Though not as vital in a simple example such as this, as the framework and # of test cases grows, this allows us to modify request details (the route itself, payload, default values, etc) in a central location vs in numerous test cases. 

Finally, the test cases themselves are defined in spec/api/dummy_rest_api_spec.rb and share data between the test cases as required. For example, the `GET` request to `/employee/{id}` randomly selects a valid ID that has been stored as the result of the previous test case, the `GET` to `/employees`. This is also the case for the `PUT` to `/update/{id}` and the `DELETE` to `/delete/{id}` which both use the ID previously created by the `POST` to `/create` test case. Obviously, this would not be optimal for large amounts of test cases, especially where parallelization is a concern and the cases should be set up to be fully idempotent instead (which, for this particular API at least, would bring up additional issues with rate limiting, etc).