require 'httparty'

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
  
  private
  
  def api_end_point(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
  
end