class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  validate :must_have_a_role, on: :update

  has_many :courses

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  def username
    email.split('@').first
  end

  def assign_default_role
    if User.count == 1
      self.add_role(:admin)
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:teacher)
      self.add_role(:student)
    end
  end

  def online?
    updated_at > 3.minutes.ago
  end

  private

  def must_have_a_role
    errors.add(:roles, 'must have at least one role') unless roles.any?
  end
end
