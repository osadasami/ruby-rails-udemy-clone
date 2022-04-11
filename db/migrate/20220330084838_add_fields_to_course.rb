# frozen_string_literal: true

class AddFieldsToCourse < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :description_short, :text
    add_column :courses, :language, :string, default: 'English', null: false
    add_column :courses, :level, :string, default: 'Beginner', null: false
    add_column :courses, :price, :decimal, default: 0, null: false
  end
end
