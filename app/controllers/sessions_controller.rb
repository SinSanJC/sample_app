class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if !params[:session][:email].blank? && !params[:session][:email].blank?
			if !user.nil? && user.authenticate(params[:session][:password])
				log_in user
				redirect_to user
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
		log_out
		redirect_to root_url
	end
end
