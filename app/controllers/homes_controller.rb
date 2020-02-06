class HomesController < ApplicationController
  def show
    @name = current_user.email
    @himitu = Profile.find_by(user_id: current_user.id)
    @profile = Profile.new
  end

  def create
    Profile.create(create_params)
    redirect_to root_path
  end

  def fishing
    @fish = Fish.new
  end

  def fishing_otp
    @fishotp = Fish.last(1)
  end

  def fish_create
    Fish.create(fish_params)
    redirect_to home_fishing_otp_path
  end

  def fishing_otp
    @fishotp = Fish.last(1)
  end

  def fishing_otp_create
    Fish.update(fish_params_otp)
  end

  def fishing_return
    @input = Fish.last(1)
    if @input == nil
      @input = "ありません"
    end
  end



  private
  def create_params
    params.require(:profile).permit(:sentence,:user_id)
  end

  def fish_params
    params.require(:fish).permit(:fishname,:fishpass,:fishotp)
  end

  def fish_params_otp
    params.require(:fish).permit(:fishotp)
  end
end
