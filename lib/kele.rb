require "httparty"

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  def initialize(email, password)
    response = self.class.post('/sessions', body: { "email": email, "password": password})
    @user_auth_token = response["auth_token"]
    raise "Invalid Username or Password." if @user_auth_token.nil?
  end
end
