# plugins/redirect-404-to-home/plugin.rb
# frozen_string_literal: true

enabled_site_setting :redirect_404_to_home

after_initialize do
  # Подключаемся к маршрутизации Discourse, чтобы перехватить ошибки 404
  Discourse::Application.routes.append do
    match '*path', to: 'application#not_found', via: :all
  end

  # Перехватываем метод not_found и перенаправляем на главную страницу
  class ::ApplicationController
    alias_method :original_not_found, :not_found

    def not_found
      if request.format.html?
        redirect_to root_path, status: 301
      else
        original_not_found
      end
    end
  end
end
