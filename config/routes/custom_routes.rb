##
# Routes for Custom
module CustomRoutes
  def self.extended(router)
    router.instance_exec do
 extend PublicRoutes
      # Insert Custom Routes here
resources :froala_assets do
  collection do
    post :upload_attachment
    get :attachment_gallery
  end
  member do
    get :get_story_file
    get :get_attachment
    delete :delete_attachment
  end
end


    end
  end
end