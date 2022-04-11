# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { user = described_class.new(email: 'admin@admin.com') }

  it 'returns email' do
    expect(user.email).to eq('admin@admin.com')
  end

  it 'returns username' do
    expect(user.username).to eq('admin')
  end
end
