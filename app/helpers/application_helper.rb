module ApplicationHelper
  def current_locale
    (params[:locale] || I18n.default_locale).to_sym
  end

  def localize(i18n)
    i18n[current_locale].present? ? i18n[current_locale] : i18n[I18n.default_locale]
  end

  def any_locale?(i18n)
    I18n.available_locales.map { |locale| i18n[locale].present? }.any?
  end
end
