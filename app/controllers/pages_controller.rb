class PagesController < ApplicationController
  def home
    @curr_user = User.find(params[:user_id])
    render 'home'
  end
end
