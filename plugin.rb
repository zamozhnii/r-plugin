# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: IDW
# url: https://github.com/zamozhnii/r_plugin.git

enabled_site_setting :enable_r_plugin

after_initialize do
  if SiteSetting.enable_r_plugin
    Discourse::Application.routes.append do
      match "/404", to: redirect('/', status: 301), via: :all
    end

    rescue_from ActionController::RoutingError do |_exception|
      redirect_to("/", status: 301)
    end
  end
end
