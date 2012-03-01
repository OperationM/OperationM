class SessionsController < ApplicationController
	def callback
    auth = request.env["omniauth.auth"]
    user = Omniuser.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Omniuser.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Login"
	end

	def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out"
  end
end
