class Course < ApplicationRecord
	extend FriendlyId

	validates :title, presence: true
	validates :description_short, presence: true
	validates :language, presence: true
	validates :level, presence: true
	validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :description, presence: true, length: {minimum: 5}
	has_rich_text :description
	belongs_to :user
	friendly_id :title, use: :slugged

	LANGUAGES = ['English', 'Chinese', 'Russian', 'Spanish', 'Japanese']
	LEVELS = ['Beginner', 'Intermediate', 'Advanced']
end
