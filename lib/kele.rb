require 'httparty'
require 'json'

class Kele
  include HTTParty
  
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
  end
  
  private
  
  def api_end_point(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
  
end