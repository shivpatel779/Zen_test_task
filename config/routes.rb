Rails.application.routes.draw do


  post '/inbound/sms/' => 'test#inbound'
  post '/outbound/sms/' => 'test#outbound'

end
