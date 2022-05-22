# frozen_string_literal: true

require 'faraday'
require 'json'

class VerboseAPIOutput < Faraday::Middleware
  def call(env)
    @app.call(env).on_complete do |response|
      path = response[:url].to_s.sub(%r{^.*/v1}, '')
      endpoint = "[#{response[:method].upcase}] #{path}"
      if response[:status] == 200
        puts "\n#{'-' * 150}\n#{endpoint}\n"
        puts "#{'-' * 67} Response Body #{'-' * 68}"
        puts JSON.pretty_generate(JSON.parse(response[:response_body]))
      else
        puts "\n#{'-' * 150}\n#{endpoint} > Status: [#{response[:status]}]\n"
        # "retry-after"=>"44", @response_headers
        puts "#{'-' * 67} Response #{'-' * 68}"
        puts response [:response_body]
      end
    end
  end
end
