# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: Your Name
# url: https://github.com/zamozhnii/r_plugin.git

after_initialize do
  # Определяем кастомное middleware для обработки 404 ошибок
  module ::Redirect404ToHome
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        # Если ошибка 404, выполняем редирект на главную страницу
        if status == 404
          return [301, { 'Location' => '/' }, ['Moved Permanently']]
        end

        # Возвращаем исходный ответ, если это не ошибка 404
        [status, headers, response]
      end
    end
  end

  # Добавляем наше middleware в цепочку, используя Rails.application.middleware
  Rails.application.config.middleware.insert_after Rack::Sendfile, ::Redirect404ToHome::Middleware
end