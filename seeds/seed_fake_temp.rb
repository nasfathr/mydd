
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'pry'

api_key = '71575488402d331035ed380ab1e43338'

def fake_temp(last_temp)
  new_temp = last_temp + (Random.rand(4) - 2).to_f / 4 + 0.5.to_f
  send_temp(new_temp)
  send_grade(2) if new_temp >= 18
  send_grade(3) if new_temp >= 19
  send_grade(4) if new_temp >= 21
  sleep(1)
  puts 'sent ' + new_temp.to_s + 'ºC'
  new_temp
end

def send_grade(grade)
  uri = URI.parse('https://api-m2x.att.com/v2/devices/5da74d20d9ec77aee3cac8c89be58bbc/streams/Grade-Quality/value')
  request = Net::HTTP::Put.new(uri)
  request.content_type = 'application/json'
  request['X-M2x-Key'] = '71575488402d331035ed380ab1e43338'
  request.body = JSON.dump('value' => grade.to_s)
  req_options = { use_ssl: uri.scheme == 'https' }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  response.body
end

def send_temp(temp)
  uri = URI.parse('https://api-m2x.att.com/v2/devices/5da74d20d9ec77aee3cac8c89be58bbc/streams/temperature/value')
  request = Net::HTTP::Put.new(uri)
  request.content_type = 'application/json'
  request['X-M2x-Key'] = '71575488402d331035ed380ab1e43338'
  request.body = JSON.dump('value' => temp.to_s)
  req_options = { use_ssl: uri.scheme == 'https' }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  response.body
end

send_grade(1)
last_temp = 13
100.times do
  last_temp = fake_temp(last_temp)
end
