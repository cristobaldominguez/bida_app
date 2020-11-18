class NotificationMailer < ApplicationMailer
  def alert_notification(user, alert)
    @user = user
    @alert = alert

    I18n.with_locale(@user.locale) do
      mail(to: email_with_name, subject: I18n.t(:notification_subject, scope: :alert, text: @alert.subject(@user.locale)))
    end
  end

  def support_notification(user, support)
    @user = user
    @support = support

    I18n.with_locale(@user.locale) do
      mail(to: email_with_name, subject: I18n.t(:notification_subject, scope: :support, text: @support.number))
    end
  end

  def inspection_notification(user, alert)
    @user = user
    @inspection = alert

    I18n.with_locale(@user.locale) do
      mail(to: email_with_name, subject: I18n.t(:notification_subject, scope: :inspection, text: @inspection.title))
    end
  end

  def todos_notification(user, todos)
    @user = user
    @todos = todos

    I18n.with_locale(@user.locale) do
      mail(to: email_with_name, subject: I18n.t(:subject, scope: [:todo, :notification_mail]))
    end
  end

  def email_with_name
    "#{@user.full_name} <#{@user.email}>"
  end
end
