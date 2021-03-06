# frozen_string_literal: true

json.extract! lesson, :id, :title, :content, :course_id, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)
json.content lesson.content.to_s
