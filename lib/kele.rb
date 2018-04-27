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

  def get_messages(page_num = 0)
    if page_num > 0
      message_url = "/message_threads?page=#{page_num}"
    else
      message_url = "/message_threads"
    end
    response = self.class.get(message_url, headers: { "authorization" => @user_auth_token})
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, stripped_text, token = nil)
    response = self.class.post("/messages", headers: { "authorization" => @user_auth_token }, body: {
        sender: sender,
        recipient_id: recipient_id,
        token: token,
        subject: subject,
        stripped_text: stripped_text
      })
    puts "Message sent" if response.success?
  end

  def get_remaining_checkpoints(chain_id)
    response = self.class.get("/enrollment_chains/#{chain_id}/checkpoints_remaining_in_section", headers: { "authorization" => @user_auth_token})
    JSON.parse(response.body)
  end
end
