class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    #debugger
  end
  
  def new
    @user = User.new
    #debugger
  end
  
  def create
    @user = User.new(user_params)
    if @user.save       # 保存が成功したら
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # 別ページにリダイレクト「redirect_to user_url(@user)」と同じ
      # redirect_to user_url(@user)
    else                # 保存が失敗したら
      render 'new'      # ？
    end
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
