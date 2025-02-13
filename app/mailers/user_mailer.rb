class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]  # 送るメールアドレス（送信者）

  def absent_notification(user)
    @user = user
    mail(
      to: @user.email,                 # 送りたいメールアドレス先（受信者）
      subject: "出席確認のご連絡"
    )
  end
end
