require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }

  describe 'GET #index' do
    before do
      sign_in user
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    let(:job) { create(:job) }

    before do
      sign_in user
      get :show, params: { id: job.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end
  end
end
