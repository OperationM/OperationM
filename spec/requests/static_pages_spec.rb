require 'spec_helper'

# 静的ページのHTMLテスト
describe "StaticPages" do
	#　対象
	subject{ page }

	# ナビゲーションのHTMLテスト
	describe "nav" do
		# root_pathに遷移
		before{ visit root_path }
		# Homeページへのリンク配置
		it{ should have_link 'Home', href: root_path }
	  # Aboutページへのリンク配置
	  it{ should have_link 'About', href: about_path }
	  # Helpページへのリンク配置
	  it{ should have_link 'Help', href: help_path }
	end

	# ログイン、ログアウト時の表示
	describe "auth" do 
		before do
			# テストモードON
			OmniAuth.config.test_mode = true
			# テスト用ユーザー
			@current_user = Omniuser.create(
				:uid => 12234,
				:provider => "facebook",
				:screen_name => "NickName",
				:name => "FirstName LastName"
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
			# root_pathで確認
			visit root_path
		end

		after do
			# テストモードOFF
			OmniAuth.config.test_mode = false
		end

		# ログイン前画面の表示
		describe "login" do
			# Log inへのリンク配置
		  it{ should have_link 'Log in', href: "/auth/facebook" }
		  # ログイン後名前表示 
	    it "display name" do
	    	click_link "Log in"
	    	should have_selector 'li', text: "FirstName LastName"
	    end
	  end

	  # ログイン後画面の表示
	  describe "logout" do
	  	before do
	  		click_link "Log in"
	  	end
	  	# ログイン後画面にログアウト表示
	  	it{ should have_link 'Log out', href: logout_path }
	  end
	end

	# ヘッダーのHTMLテスト
	describe "header" do
		# root_pathに遷移
		before{ visit root_path }
		# ロゴの配置と属性の設定
		it{ should have_selector 'img', alt: "Moogle" }
		# ロゴをroot_pathにリンク
		it{ should have_link 'Moogle', href: root_path }
		# 検索用テキストフィールドの配置
		it{ should have_selector 'input', type: "text" }
		# 検索実行用のボタンの配置
		it{ should have_selector 'input', type: "button" }
	end

	# フッターのHTMLテスト
	describe "footer" do
		# root_pathに遷移
		before{ visit root_path }
	end

	# 静的ページの共通
	shared_examples_for "all static pages" do
		# サイトタイトルにページタイトルを追加
		it{ should have_selector 'title', text: full_title(page_title) }
	end

	# Home遷移時のHTMLテスト
	describe "Home page" do
		# home_pathに遷移
		before{ visit home_path }
		# ページタイトルはHome
		let(:page_title){'Home'}
		# 共通テスト実行
		it_should_behave_like "all static pages"
	end

	# About遷移時のHTMLテスト
	describe "About page" do
		# about_pathに遷移
		before{ visit about_path }
		# ページタイトルはAbout
		let(:page_title){'About'}
		# 共通テスト実行
		it_should_behave_like "all static pages"
	end

	# Help遷移時のHTMLテスト
	describe "Help page" do
		# help_pathに遷移
		before{ visit help_path }
		# ページタイトルはHelp
		let(:page_title){'Help'}
		# 共通テスト実行
		it_should_behave_like "all static pages"
	end
end
