# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursePolicy do
  subject { described_class.new(user, record) }

  context 'guest' do
    let(:user) { nil }
    let(:record) { nil }

    it { is_expected.to forbid_actions(:new, :create, :edit, :update, :destroy, :purchased, :pending_review, :my) }
  end

  context 'admin' do
    let(:user) do
      user = User.create(email: 'test@test.com', password: 'test@test.com', confirmed_at: DateTime.now)
      user.add_role(:admin)
      user
    end
    let(:record) { Course.create }

    it { is_expected.to permit_actions(:new, :create, :edit, :update, :destroy, :purchased, :pending_review, :my) }
  end

  context 'student' do
    let(:user) do
      User.create(email: 'test@test.com', password: 'test@test.com', confirmed_at: DateTime.now)
    end
    let(:record) { Course.create }

    it { is_expected.to permit_actions(:purchased, :pending_review) }
    it { is_expected.to forbid_actions(:new, :create, :edit, :update, :destroy, :my) }
  end

  context 'teacher' do
    let(:user) do
      user = User.create(email: 'test@test.com', password: 'test@test.com', confirmed_at: DateTime.now)
      user.add_role(:teacher)
      user
    end

    context 'my course' do
      let(:record) { Course.create(user: user) }

      it { is_expected.to permit_actions(:purchased, :pending_review, :my, :new, :create, :edit, :update, :destroy) }
    end

    context 'not my course' do
      let(:record) { Course.create }

      it { is_expected.to permit_actions(:purchased, :pending_review, :my, :new, :create) }
      it { is_expected.to forbid_actions(:edit, :update, :destroy) }
    end
  end
end
