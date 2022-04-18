require 'rails_helper'

RSpec.describe EnrollmentsController, type: :request do
  describe 'index' do
    context 'guest' do
      it 'redirects to user sign in page' do
        get enrollments_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    # context 'admin' do
    #   it 'it opens page with all enrollments' do
    #     get enrollments_path
    #     expect(response).to be_successful
    #   end
    # end

  end
end
