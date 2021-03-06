# frozen_string_literal: true

class Course < ApplicationRecord
  extend FriendlyId
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller&.current_user || nil }

  validates :title, presence: true
  validates :description_short, presence: true
  validates :language, presence: true
  validates :level, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 5 }
  has_rich_text :description
  friendly_id :title, use: :slugged
  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  LANGUAGES = %w[English Chinese Russian Spanish Japanese].freeze
  LEVELS = %w[Beginner Intermediate Advanced].freeze

  def bought_by?(user)
    enrollments.where(user: user, course: self).exists?
  end

  def update_rating
    update(average_rating: enrollments.average(:rating)&.round(1).to_f)
  end
end
