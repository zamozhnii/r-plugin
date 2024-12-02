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

  # Добавляем middleware правильно, чтобы избежать ошибки с FrozenError
  Rails.application.config.middleware.insert_before(
    Rails::Rack::Logger,  # Место, куда вставить middleware
    ::Redirect404ToHome::Middleware
  )
end