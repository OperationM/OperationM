require 'spec_helper'

describe "Comments" 

#  before do
#    # テストモードON
#    OmniAuth.config.test_mode = true
#    # テスト用ユーザー
#    @current_user = Factory(:omniuser)
#
#    @movie = Factory(:movie)
#    # モック作成
#    OmniAuth.config.mock_auth[:facebook] = {
#      "uid" => @current_user.uid,
#      "provider" => @current_user.provider,
#      "info" => {
#        "nickname" => @current_user.screen_name,
#        "name" => @current_user.name,
#      }
#    }
#    # root_pathで確認
#    visit root_path
#    click_link "Log in with facebook"
#  end
#
#  after do
#    # テストモードOFF
#    OmniAuth.config.test_mode = false
#  end
#
#  describe "creation" do
#
#    describe "failuer" do
#
#      it "should not make a new comment" do
#        lambda do
#          visit movie_path(@movie)
#          fill_in :comment_comment, :with => ""
#          click_button
#        end.should_not change(Comment, :count)
#      end
#    end
#  end
#end
