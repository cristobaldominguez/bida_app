class LocalesController < ApplicationController
  def index
    @locales = params[:i18n].scan(/[\w.]+/)

    json_params = {}
    @locales.each do |translation|
      name = translation.split('.').last.to_sym
      json_params[name] = I18n.t(translation)
    end

    render json: json_params, status: :ok
  end
end
