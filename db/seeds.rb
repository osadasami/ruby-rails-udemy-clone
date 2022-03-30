user = User.create(
	email: 'admin@admin.com',
	password: 'admin@admin.com',
	password_confirmation: 'admin@admin.com',
	confirmed_at: DateTime.now,
)

30.times do
	Course.create(
		title: Faker::Educator.course_name,
		description_short: Faker::Lorem.paragraph(sentence_count: 3),
		description: Faker::Lorem.paragraph(sentence_count: 10),
		user: user,
		language: ['English', 'Chinese', 'Russian'].sample,
		level: ['Beginner', 'Intermediate', 'Advanced'].sample,
		price: Faker::Number.between(from: 10, to: 250),
	)
end