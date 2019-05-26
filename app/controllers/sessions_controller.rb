class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if !params[:session][:email].blank? && !params[:session][:email].blank?
			if !user.nil? && user.authenticate(params[:session][:password])
				if user.activated?
					log_in user
					params[:session][:remember_me] == '1' ? remember(user) : forget(user)
					redirect_to root_url
				else
					message  = "Account not activated. "
					message += "Check your email for the activation link."
					flash[:warning] = message
					render 'new'
				end
			else
				params[:session][:email] = params[:session][:email].downcase
				flash.now[:danger] = 'Invalid email/password combination'
				render 'new'
			end
		else
			params[:session][:email] = params[:session][:email].downcase
			flash.now[:danger] = 'Insert user and password'
			render 'new'
		end
	end

	def destroy
		if logged_in?
			log_out
		end
		redirect_to root_url
	end
end
