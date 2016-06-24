class Admin::UsersController < Admin::BaseController

  before_action :ensure_valid_user, except: [:index]
  before_action :ensure_not_self, only: [:enable, :disable]

  def index
    @users = User.verified.paginate(page: params[:page], per_page: 4)
  end

  def show
  end

  def enable
    if @user.mark_enabled
      redirect_to admin_user_path(@user)
    else
      redirect_to :back, alert: "Sorry, action failed."
    end
  end

  def disable
    if @user.mark_disabled
      redirect_to admin_user_path(@user)
    else
      redirect_to :back, alert: "Sorry, action failed."
    end
  end

  private

  def ensure_valid_user
    @user = User.verified.find_by(id: params[:id])
    if @user.nil?
      redirect_to :back, alert: "Sorry, invalid or unverified user."
    end
  end

  def ensure_not_self
    if current_user.id == params[:id].to_i
      redirect_to :back, alert: "You cannot enable or disable yourself."
    end
  end

end
