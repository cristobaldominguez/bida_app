class PagesController < ApplicationController
  def index
    @locale = set_locale
  end

  def no_permission; end
end
