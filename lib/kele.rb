require "httparty"
require "json"
require "./lib/roadmap"

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  def initialize(email, password)
    response = self.class.post('/sessions', body: { "email": email, "password": password})
    @user_auth_token = response["auth_token"]
    raise "Invalid Username or Password." if @user_auth_token.nil?
  end

  def get_me
    response = self.class.get('/users/me', headers: {"authorization" => @user_auth_token})
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @user_auth_token})
    available = []
    JSON.parse(response.body).each do |availability|
      if availability["booked"] == nil
        available << availability
      end
    end
    available
  end
end
