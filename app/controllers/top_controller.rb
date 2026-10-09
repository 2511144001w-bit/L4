class TopController < ApplicationController
  # 追加
  def main
    if session[:login_uid].nil?
      render :login
    else
      render :main
    end
  end

  def login
    if params[:uid] == "kindai" && params[:pass] == "sanriko"
      session[:login_uid] = params[:uid]
      redirect_to top_main_path
    else
      render :error
    end
  end
end
