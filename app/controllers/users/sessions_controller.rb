# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :authenticate_with_two_factor, only: [:create]

  private
  def authenticate_with_two_factor
    # strong parameters
    user_params = params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)

    if user_params[:email]
      user = User.find_by(email: user_params[:email])

    elsif user_params[:otp_attempt].present? && session[:otp_user_id]
      user = User.find(session[:otp_user_id])
    end
    self.resource = user

    return unless user && user.otp_required_for_login

    if user_params[:email]
      if user.valid_password?(user_params[:password])
        session[:otp_user_id] = user.id
        render 'devise/sessions/two_factor' and return
      end

    elsif user_params[:otp_attempt].present? && session[:otp_user_id]
      if user.validate_and_consume_otp!(user_params[:otp_attempt])
        session.delete(:otp_user_id)
        sign_in(user) and return
      else
        flash.now[:alert] = 'Invalid two-factor code.'
        render :two_factor and return
      end
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
