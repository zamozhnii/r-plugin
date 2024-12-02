# name: r_plugin
# about: Redirects all 404 errors to the home page
# version: 0.1
# authors: Your Name
# url: https://github.com/zamozhnii/r_plugin.git

after_initialize do
  # Мы не будем изменять существующий массив middleware напрямую
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

  # Добавляем middleware в стек, не изменяя замороженный массив
  Rails.application.config.middleware.use ::Redirect404ToHome::Middleware if SiteSetting.r_plugin_enabled
end