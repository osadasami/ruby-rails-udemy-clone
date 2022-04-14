# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { user = described_class.create(email: 'test@test.com', password: 'test@test.com', confirmed_at: Time.now) }

  it 'returns email' do
    expect(user.email).to eq('test@test.com')
  end

  it 'returns username' do
    expect(user.username).to eq('test')
  end

  it 'has student role after creating' do
    expect(user.has_role?(:student)).to be(true)
  end
end
