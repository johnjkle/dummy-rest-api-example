# frozen_string_literal: true

require 'rspec'
require 'faker'
require 'json'
require './helpers/dummy_rest_api'
require './helpers/faraday'

BASE_URL = 'https://dummy.restapiexample.com/api/v1/'

RSpec.configure do |config|
  config.before(:all) do
    @connection = Faraday.new(url: BASE_URL.to_s) do |faraday|
      faraday.request :retry, max: 2, interval: 45, retry_statuses: [429]
      faraday.use VerboseAPIOutput
    end
  end
end
