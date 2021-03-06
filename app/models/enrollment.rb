# frozen_string_literal: true

class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user

  validates :user, :course, presence: true
  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id
  validate :cant_subscribe_to_own_course
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?
  validates :rating, numericality: { only_integer: true, in: 1..5 }, if: :review?

  scope :pending_review, -> { where(rating: nil, review: ['', nil]) }

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  after_save :update_rating
  after_destroy :update_rating

  def update_rating
    return unless rating

    course.update_rating
  end

  def to_s
    "#{user.email}-#{course.title}"
  end

  private

  def cant_subscribe_to_own_course
    if new_record? && user_id.present? && user_id == course.user_id
      errors.add(:base, 'You can not subscribe to your own course')
    end
  end
end
