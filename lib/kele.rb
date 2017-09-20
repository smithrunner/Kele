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
  
  
  private
  
  def api_end_point(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
  
end