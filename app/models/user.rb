# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  validate :must_have_a_role, on: :update

  has_many :courses
  has_many :enrollments

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  def username
    email.split('@').first
  end

  def assign_default_role
    add_role(:admin) if User.count == 1
    add_role(:teacher)
    add_role(:student)
  end

  def online?
    updated_at > 3.minutes.ago
  end

  def to_s
    email
  end

  def buy_course(course)
    enrollments.create(course: course, price: course.price)
  end

  private

  def must_have_a_role
    errors.add(:roles, 'must have at least one role') unless roles.any?
  end
end
