# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: Your Name
# url: https://github.com/zamozhnii/r_plugin.git

after_initialize do
  # Перехватываем ошибки 404 и перенаправляем на главную страницу
  Discourse::Application.routes.append do
    match "/404", to: redirect('/', status: 301), via: :all
  end

  rescue_from ActionController::RoutingError do |_exception|
    redirect_to("/", status: 301)
  end
end