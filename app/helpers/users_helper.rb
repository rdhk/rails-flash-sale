module UsersHelper

  def enabled_or_disabled_user(user)
    if user.enabled
     raw('<span class="label label-success"><i class="fa fa-check" aria-hidden="true"></i></span>')
    else
      raw('<span class="label label-danger"><i class="fa fa-remove" aria-hidden="true"></i></span>')
    end
  end

  def enable_or_disable_action(user)
    if user.enabled
      link_to "Disable User", disable_admin_user_path(user), data: {confirm: 'Are you sure?'}, method: :post, class:"btn btn-danger btn-sm"
    else
      link_to "Enable User", enable_admin_user_path(user), data: {confirm: 'Are you sure you want to mark the order as delivered?'} ,method: :post, class:"btn btn-success btn-sm"
    end
  end

end
