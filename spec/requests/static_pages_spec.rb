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

		it_should_behave_like "all static pages"
	end

	# About遷移時のHTMLテスト
	describe "About page" do
		# about_pathに遷移
		before{ visit about_path }

		# ページタイトルはAbout
		let(:page_title){'About'}

		it_should_behave_like "all static pages"
	end

	# Help遷移時のHTMLテスト
	describe "Help page" do
		# help_pathに遷移
		before{ visit help_path }

		# ページタイトルはHelp
		let(:page_title){'Help'}

		it_should_behave_like "all static pages"
	end

end
