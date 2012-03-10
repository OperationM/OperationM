class SessionsController < ApplicationController
  # OAuthのコールバック。ログイン時処理
	def callback
    # raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    # user = Omniuser.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Omniuser.create_with_omniauth(auth)
    # ログイン毎にユーザーのグループ情報とリンクしたいので見つけて更新 or 新規で実装
    user = Omniuser.update_with_omniauth(auth) || Omniuser.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Login"
	end

  # ログアウト時処理
	def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out"
  end
end
