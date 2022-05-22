# frozen_string_literal: true

# Helper class to simplify API requests sent to the Dummy REST API:
class DummyRestAPIExample
  def initialize(connection)
    @connection = connection
  end

  def get_employees
    response = @connection.get('employees')
    response.env
  end

  def get_employee(id)
    response = @connection.get("employee/#{id}")
    response.env
  end

  def create_employee(request_body = {})
    response = @connection.post('create') do |request|
      request.body = {
        name: request_body[:name],
        salary: request_body[:salary] || rand(50_000..950_000),
        age: request_body[:age] || rand(18..65)
      }.to_json
    end
    response.env
  end

  def update_employee(id, request_body = {})
    response = @connection.put("update/#{id}") do |request|
      request.body = {
        name: request_body[:name],
        salary: request_body[:salary],
        age: request_body[:age]
      }.to_json
    end
    response.env
  end

  def delete_employee(id)
    response = @connection.delete("delete/#{id}")
    response.env
  end
end
