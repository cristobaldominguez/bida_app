class NotificationMailer < ApplicationMailer
  def alert_notification(user, alert)
    @user = user
    @alert = alert

    I18n.with_locale(@user.locale) do
      mail(to: @user.email, subject: I18n.t(:notification_subject, scope: :alert, text: @alert.subject))
    end
  end

  def support_notification(user, support)
    @user = user
    @support = support

    I18n.with_locale(@user.locale) do
      mail(to: @user.email, subject: I18n.t(:notification_subject, scope: :support, text: @support.number))
    end
  end

  def inspection_notification(user, alert)
    @user = user
    @inspection = alert

    I18n.with_locale(@user.locale) do
      mail(to: @user.email, subject: I18n.t(:notification_subject, scope: :inspection, text: @inspection.title))
    end
  end
end
