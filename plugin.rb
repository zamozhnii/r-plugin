# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: Your Name
# url: https://github.com/zamozhnii/r_plugin.git

after_initialize do
  # Создаём middleware, которое будет перехватывать ошибки 404
  module ::Redirect404ToHome
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        # Если ошибка 404, перенаправляем на главную страницу
        if status == 404
          return [301, { 'Location' => '/' }, ['Moved Permanently']]
        end

        # Возвращаем оригинальный ответ, если это не ошибка 404
        [status, headers, response]
      end
    end
  end

  # Вставляем middleware в конфигурацию Rails, чтобы обрабатывать 404 ошибки
  Rails.application.config.middleware.use ::Redirect404ToHome::Middleware
end