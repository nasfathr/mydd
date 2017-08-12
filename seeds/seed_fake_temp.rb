
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

def fake_humidity(last_temp)
  new_temp = last_temp + (Random.rand(4) - 2).to_f / 4 + 0.2.to_f
  send_humidity(new_temp)
  sleep(1)
  puts 'sent ' + new_temp.to_s + '%'
  new_temp
end

def send_grade(grade)
  uri = URI.parse('https://api-m2x.att.com/v2/devices/9346b77b144e5e00e40cc7f9e6220840/streams/Grade-Quality/value')
  request = Net::HTTP::Put.new(uri)
  request.content_type = 'application/json'
  request['X-M2x-Key'] = 'de395ffe039fc422ee72ccd017165105'
  request.body = JSON.dump('value' => grade.to_s)
  req_options = { use_ssl: uri.scheme == 'https' }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts response.body
end

def send_temp(temp)
  uri = URI.parse('https://api-m2x.att.com/v2/devices/9346b77b144e5e00e40cc7f9e6220840/streams/temperature/value')
  request = Net::HTTP::Put.new(uri)
  request.content_type = 'application/json'
  request['X-M2x-Key'] = 'de395ffe039fc422ee72ccd017165105'
  request.body = JSON.dump('value' => temp.to_s)
  req_options = { use_ssl: uri.scheme == 'https' }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts response.body
end

def send_humidity(temp)
  uri = URI.parse('https://api-m2x.att.com/v2/devices/9346b77b144e5e00e40cc7f9e6220840/streams/Humidity/value')
  request = Net::HTTP::Put.new(uri)
  request.content_type = 'application/json'
  request['X-M2x-Key'] = 'de395ffe039fc422ee72ccd017165105'
  request.body = JSON.dump('value' => temp.to_s)
  req_options = { use_ssl: uri.scheme == 'https' }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts response.body
end

# send_grade(1)
last_temp = 74
last_humidity = 20

4.times do
  # last_temp = fake_temp(last_temp)
  last_humidity = fake_humidity(last_humidity)
end
