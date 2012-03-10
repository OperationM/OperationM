class ApplicationController < ActionController::Base
	protect_from_forgery
  helper_method :current_user
  helper_method :admin?
  helper_method :member?

  private
  # ログインユーザーを返す
  def current_user
    @current_user ||= Omniuser.find(session[:user_id]) if session[:user_id]
  end

  # ログインユーザーが管理グループに属しているかどうかを返す
  def admin?
  	if current_user
  		return @current_user.belongs_to_admin_group?
  	else
  		return false
  	end
  	return false
  end

  # ログインユーザーがミューソグループに属しているかどうかを返す
  def member?
  	if current_user
  		return @current_user.belongs_to_member_group?
  	else
  		return false
  	end
  	return false
  end
end
