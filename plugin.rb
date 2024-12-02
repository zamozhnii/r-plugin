# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: Your Name
# url: https://github.com/zamozhnii/r_plugin.git

after_initialize do
  # Создаем middleware для обработки ошибок 404
  module ::Redirect404ToHome
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        # Проверяем, является ли ошибка 404
        if status == 404
          # Если ошибка 404, делаем редирект на главную страницу с кодом 301
          return [301, { 'Location' => '/' }, ['Moved Permanently']]
        end

        # Если ошибка не 404, возвращаем исходный ответ
        [status, headers, response]
      end
    end
  end

  # Добавляем middleware всегда, без проверки настройки
  Rails.application.config.middleware.use ::Redirect404ToHome::Middleware
end