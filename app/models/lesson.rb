class Lesson < ApplicationRecord
  belongs_to :course
  has_rich_text :content
  validates :title, :content, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller&.current_user || nil }
end
