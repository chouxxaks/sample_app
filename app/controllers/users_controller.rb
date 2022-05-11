class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy] # beforフィルター：何らかの処理が実行される直前に特定のメソッドを実行する仕組み
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
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
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # 別ページにリダイレクト「redirect_to user_url(@user)」と同じ
      # redirect_to user_url(@user)
    else                # 保存が失敗したら
      render 'new'      # newページを描画する
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeアクション
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
