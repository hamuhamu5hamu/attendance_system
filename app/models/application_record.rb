class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  def self.send_absent_students_email
    absent_students = User.includes(:attendances).where.not(id: Attendance.where(date: Date.today).pluck(:user_id))
    absent_students.each do |user|
      # ここで、出席していない生徒の処理や通知、メール送信を行います。
      # 例えば、メール送信のコードをここに書きます。
      UserMailer.absent_notification(user).deliver_now
    end
  end
end
