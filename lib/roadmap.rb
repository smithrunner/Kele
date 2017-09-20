module Roadmap
  def get_roadmap(roadmap_id)
    response = self.class.get(api_end_point("roadmaps/#{roadmap_id}"), headers: {"authorization" => @auth_token})
    @road_map = JSON.parse(response.body)
  end
  
  def get_checkpoint(checkpoint_id)
    response = self.class.get(api_end_point("checkpoints/#{checkpoint_id}"), headers: {"authorization" => @auth_token})
  end
end