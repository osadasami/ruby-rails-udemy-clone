1.upto(10) do |n|
	user = User.create(
		email: "admin#{n}@admin.com",
		password: 'admin@admin.com',
		password_confirmation: 'admin@admin.com',
		confirmed_at: DateTime.now,
	)
end

30.times do
	Course.create(
		title: Faker::Educator.course_name,
		description_short: Faker::Lorem.paragraph(sentence_count: 3),
		description: Faker::Lorem.paragraph(sentence_count: 10),
		user: User.all.sample,
		language: Course::LANGUAGES.sample,
		level: Course::LEVELS.sample,
		price: Faker::Number.between(from: 10, to: 250),
	)
end