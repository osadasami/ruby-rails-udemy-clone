class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id
  validate :cant_subscribe_to_own_course

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    "#{user.email}-#{course.title}"
  end

  private

  def cant_subscribe_to_own_course
    if new_record? && user_id.present? && user_id == course.user_id
      errors.add(:base, "You can not subscribe to your own course")
    end
  end
end
