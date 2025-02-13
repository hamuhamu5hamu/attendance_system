# app/models/user.rb
class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  validates :classname, presence: true
end