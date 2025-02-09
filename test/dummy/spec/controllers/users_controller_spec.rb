require 'spec_helper'

describe Ishapi::UsersController do
  render_views
  routes { Ishapi::Engine.routes }
  before :each do
    do_setup
  end

  describe '#login' do
    it 'sends jwt_token' do
      post :login, format: :json, params: { email: @user.email, password: '123412341234' }
      response.should be_success
      puts! response.body, 'the respp'

      result = JSON.parse response.body
      result['jwt_token'].should_not be nil
    end
  end

  describe '#account' do
    it 'renders' do
      @jwt_token = encode(user_id: @user.id.to_s)
      get :account, format: :json, params: { jwt_token: @jwt_token }
      response.should be_success
    end
  end

end
