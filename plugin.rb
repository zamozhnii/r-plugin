# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: IDW
# url: https://github.com/zamozhnii/r_plugin.git

enabled_site_setting :enable_r_plugin

def configure_routes
  Discourse::Application.routes.prepend do
    if SiteSetting.enable_r_plugin
      match "/404", to: redirect('/', status: 301), via: :all
      rescue_from ActionController::RoutingError do |_exception|
        redirect_to("/", status: 301)
      end
    else
      # Ничего не делаем, если настройка отключена
      # Или можно удалить существующие маршруты, если они были добавлены ранее
    end
  end
end

after_initialize do
  configure_routes

  DiscourseEvent.on(:site_setting_updated) do |name, old_val, new_val|
    if name == "enable_r_plugin"
      Rails.application.reload_routes! if old_val != new_val
    end
  end
end