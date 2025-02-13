# app/models/attendance.rb
class Attendance < ApplicationRecord
  belongs_to :user
  validates :date, presence: true
  validates :status, presence: true
  def self.send_absent_students_email
    absent_students = User.includes(:attendances).where.not(id: Attendance.where(date: Date.today).pluck(:user_id))
    Rails.logger.info "Absent students: #{absent_students.map(&:name).join(', ')}"  # ログに出力

    absent_students.each do |user|
      Rails.logger.info "Sending email to #{user.email}"  # ログに出力
      UserMailer.absent_notification(user).deliver_now
    end
  end
end