class NotificationMailer < ApplicationMailer
  def alert_notification(user, alert)
    @user = user
    @alert = alert

    mail(
      to: @user.email,
      subject: "[BIDA] › Ticket Alert #{@alert.subject}"
    )
  end

  def support_notification(user, support)
    @user = user
    @support = support

    mail(
      to: @user.email,
      subject: "[BIDA] › Ticket Support: #{@support.number}"
    )
  end

  def inspection_notification(user, alert)
    @user = user
    @inspection = alert

    mail(
      to: @user.email,
      subject: "[BIDA] › Ticket Inspection: #{@inspection.title}"
    )
  end
end
