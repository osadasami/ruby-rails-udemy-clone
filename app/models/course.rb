class Course < ApplicationRecord
	extend FriendlyId

	validates :title, presence: true
	validates :description, presence: true, length: {minimum: 5}
	has_rich_text :description
	belongs_to :user
	friendly_id :title, use: :slugged
end
