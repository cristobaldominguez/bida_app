class LocalesController < ApplicationController

  def index
    locales_array = params[:i18n].scan(/[\w.]+/)

    @locale = {}
    locales_array.each do |translation|
      name = translation.split('.').last.to_sym
      @locale[name] = I18n.t(translation)
    end

    respond_to do |f|
      f.json { render json: @locale, status: :ok }
    end
  end
end
