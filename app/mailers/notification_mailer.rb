class NotificationMailer < ApplicationMailer
  def support_notification(user, support)
    @user = user
    @support = support

    mail(
      to: @user.email,
      subject: "[BIDA] New Support: #{@support.number}"
    )
  end

  def alert_notification(user, alert)
    @user = user
    @alert = alert

    mail(
      to: @user.email,
      subject: "[BIDA] New Alert: #{@alert.title}"
    )
  end
end
