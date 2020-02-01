class HomeController < ApplicationController
  def show
    @name = current_user.email
  end
end
