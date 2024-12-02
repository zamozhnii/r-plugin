# name: r-plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: Your Name
# url: https://github.com/zamozhnii/r-plugin.git

enabled_site_setting :r-plugin_enabled

after_initialize do
  # Middleware для обработки ошибок 404
  module ::Redirect404ToHome
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        # Проверяем, является ли ошибка 404
        if status == 404
          # Создаем редирект на главную страницу с кодом 301
          return [301, { 'Location' => '/' }, ['Moved Permanently']]
        end

        # Если ошибка не 404, возвращаем исходный ответ
        [status, headers, response]
      end
    end
  end

  # Добавляем middleware в приложение Discourse
  Discourse::Application.routes.append do
    # Подключаем наш middleware
    Rails.application.config.middleware.use ::Redirect404ToHome::Middleware
  end
end
