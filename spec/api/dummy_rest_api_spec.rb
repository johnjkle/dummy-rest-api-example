# frozen_string_literal: true

require './spec/spec_helper'

describe '"https://dummy.restapiexample.com/" CRUD test cases' do
  before(:all) do
    @dummy_rest_api = DummyRestAPIExample.new(@connection)

    @employees = []
    @new_employee_record = {}
  end

  it '[GET] /employees' do
    @response = @dummy_rest_api.get_employees
    expect(@response.status).to eql(200)
    @response_body = JSON.parse(@response.body)
    expect(@response_body['status']).to eql('success')
    expect(@response_body['message']).to eql('Successfully! All records has been fetched.')
    expect(@response_body['data'].count).to be > 0
    @response_body['data'].each { |record| @employees.push(record) }
  end

  it '[GET] /employee/{id}' do
    employee_id = @employees.sample['id']

    @response = @dummy_rest_api.get_employee(employee_id)
    expect(@response.status).to eql(200)
    @response_body = JSON.parse(@response.body)
    expect(@response_body['status']).to eql('success')
    expect(@response_body['message']).to eql('Successfully! Record has been fetched.')
    expect(@response_body['data'].count).to be > 0
  end

  it '[POST] /create' do
    @response = @dummy_rest_api.create_employee(name: Faker::Name.name)
    expect(@response.status).to eql(200)
    @response_body = JSON.parse(@response.body)
    expect(@response_body['status']).to eql('success')
    expect(@response_body['message']).to eql('Successfully! Record has been added.')
    expect(@response_body['data']).not_to be_empty
    @new_employee_record.merge!(@response_body['data'])
  end

  it '[PUT] /update/{id}' do
    @original_employee_record = @new_employee_record
    @response = @dummy_rest_api.update_employee(@new_employee_record['id'],
                                                name: Faker::Name.name,
                                                salary: rand(50_000..950_000),
                                                age: rand(18..65)
    )
    expect(@response.status).to eql(200)
    @response_body = JSON.parse(@response.body)
    expect(@response_body['status']).to eql('success')
    expect(@response_body['message']).to eql('Successfully! Record has been updated.')
    expect(@response_body['data'].first[0]['name']).not_to be_eql(@original_employee_record['name'])
    expect(@response_body['data'].first[0]['salary']).not_to be_eql(@original_employee_record['salary'])
    expect(@response_body['data'].first[0]['age']).not_to be_eql(@original_employee_record['age'])
  end

  it '[DELETE] /delete/{id}' do
    employee_id = @new_employee_record['id']

    @response = @dummy_rest_api.delete_employee(employee_id)
    expect(@response.status).to eql(200)
    @response_body = JSON.parse(@response.body)
    expect(@response_body['status']).to eql('success')
    expect(@response_body['message']).to eql('Successfully! Record has been deleted')
  end
end
