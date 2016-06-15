module AdminAuthorization
  extend ActiveSupport::Concern

  private

  def authorize_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You don't have privilege to access this section."
    end
  end
end
