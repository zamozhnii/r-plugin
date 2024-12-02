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

        # Если ответ - 404, перенаправляем на главную страницу
        if status == 404
          return [301, { 'Location' => '/' }, ['Moved Permanently']]
        end

        # Если это не ошибка 404, возвращаем исходный ответ
        [status, headers, response]
      end
    end
  end

  # Используем Rack::Builder для добавления middleware в цепочку
  Discourse::Application.routes.append do
    # Вставляем наше middleware в конец цепочки
    middleware.use ::Redirect404ToHome::Middleware
  end
end