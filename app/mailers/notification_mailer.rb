class NotificationMailer < ApplicationMailer
  def alert_notification(user, alert)
    @user = user
    @alert = alert

    mail( to: @user.email, subject: I18n.t(:notification_subject, scope: :alert, text: @alert.subject) )
  end

  def support_notification(user, support)
    @user = user
    @support = support

    mail(to: @user.email, subject: I18n.t(:notification_subject, scope: :support, text: @support.number))
  end

  def inspection_notification(user, alert)
    @user = user
    @inspection = alert

    mail( to: @user.email, subject: I18n.t(:notification_subject, scope: :inspection, text: @inspection.title) )
  end
end
