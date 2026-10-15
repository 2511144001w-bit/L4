class TopController < ApplicationController
  def main
    if session[:login_uid].nil?
      render :login
    else
      render :main
    end
  end

  def login
    user = User.find_by(uid: params[:uid])
    if user && BCrypt::Password.new(user.pass) == params[:pass]
      session[:login_uid] = user.uid
      redirect_to top_main_path
    else
      render :error
    end
  end

  def logout
    session.delete(:login_uid)
    redirect_to root_path
  end
end
