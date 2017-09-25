require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  include Roadmap
  
  def initialize(email, password)
    response = self.class.post(api_end_point("sessions"), body: {"email": email, "password": password})
    if response && response['auth_token']
      @auth_token = response["auth_token"]
      puts "Login Successful."
    else 
      puts "Invalid Login"
    end
  end
  
  def get_me
    response = self.class.get(api_end_point("users/me"), headers: {"authorization" => @auth_token})
    @user_data = JSON.parse(response.body)
    puts "Your mentor's ID is: #{@user_data['current_enrollment']['mentor_id']}"
  end
  
  def get_mentor_availability(mentor_id)
    response = self.class.get(api_end_point("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @auth_token})
    @mentor_availability = JSON.parse(response.body)
  end
  
  def get_messages(page_number = 0)
    response = self.class.get(api_end_point("message_threads"), headers: {"authorization" => @auth_token})
    @messages = JSON.parse(response.body)
    if page_number == 0
      return @messages
    else
      return @messages[page_number]
    end
  end
  
  def create_message(sender, recipient_id, subject, text, token=nil)
    if token.nil?
      response = self.class.post(api_end_point("messages"), body: {"sender": sender, "recipient_id": recipient_id, "subject": subject, "stripped-text": text}, headers: {"authorization" => @auth_token})
    else
      response = self.class.post(api_end_point("messages"), body: {"sender": sender, "recipient_id": recipient_id, "token": token, "subject": subject, "stripped-text": text}, headers: {"authorization" => @auth_token})
    end
  end
  
  def create_submission(checkpoint_id, enrollment_id)
    response = self.class.post(api_end_point("checkpoint_submissions"), body: {"checkpoint_id": checkpoint_id, "enrollment_id": enrollment_id}, headers: {"authorization" => @auth_token})
  end
  
  private
  
  def api_end_point(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
  
end