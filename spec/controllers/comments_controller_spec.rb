require 'spec_helper'

describe CommentsController do
  render_views
  before do
    # テストモードON
    OmniAuth.config.test_mode = true
    # テスト用ユーザー
    @current_user = Omniuser.create(
      :uid => 12234,
      :provider => "facebook",
      :screen_name => "NickName",
      :name => "FirstName LastName",
      :admin => true,
      :member => true,
    )
    # モック作成
    OmniAuth.config.mock_auth[:facebook] = {
      "uid" => @current_user.uid,
      "provider" => @current_user.provider,
      "info" => {
        "nickname" => @current_user.screen_name,
        "name" => @current_user.name,
      }
    }

    @request.session = ActionController::TestSession.new
    @request.session[:user_id] = 1
  end

  after do
    # テストモードOFF
    OmniAuth.config.test_mode = false
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @movie = Factory(:movie)
        @attr = { :comment => "", :movie_id => @movie.id }
      end

      it "should not create a comment" do
        lambda do
          post :create, :comment => @attr
        end.should_not change(Comment, :count)
      end

      it "should render the movie index page" do
        post :create, :comment => @attr
        response.should redirect_to(movie_path(@movie))
      end
    end

    describe "success" do

      before(:each) do
        @movie = Factory(:movie)
        @attr = { :comment => "test comment", :movie_id => @movie.id}
      end

      it "should create a comment" do
        lambda do
          post :create, :comment => @attr
        end.should change(Comment, :count).by(1)
      end

      it "should create comment using Ajax" do
        lambda do
          xhr :post, :create, :comment => @attr
          response.should be_success
        end.should change(Comment, :count).by(1)
      end

      it "should redirect to the movie page" do
        post :create, :comment => @attr
        response.should redirect_to(movie_path(@movie))
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    describe "for an authorized user" do

      before(:each) do
        @user = Factory(:omniuser)
        @movie = Factory(:movie)
        @comment = Factory(:comment, :omniuser => @user)
      end

      it "should destroy the comment" do
        lambda do
          delete :destroy, :id => @comment
        end.should change(Comment, :count).by(-1)
      end

      it "should destroy a comment using Ajax" do
        lambda do
          xhr :delete, :destroy, :id => @comment
          response.should be_success
        end.should change(Comment, :count).by(-1)
      end
    end
  end
end
