# frozen_string_literal: true

json.array! @enrollments, partial: 'enrollments/enrollment', as: :enrollment
