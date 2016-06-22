module ApplicationHelper

  def user_account_actions
    if signed_in?
      "<li class='dropdown'>
          <a href='#' class='dropdown-toggle' data-toggle='dropdown' role='button' aria-expanded='false'>My Account <span class='caret'></span></a>
          <ul class='dropdown-menu' role='menu'>

          <li>#{link_to 'My Orders', orders_path}</li>
            <li class='divider'></li>
            <li><a href='#'>Separated link</a></li>
            <li class='divider'></li>
            <li><a href='#'>One more separated link</a></li>
          </ul>
        </li>".html_safe
    end
  end

  def admin_account_actions
    if signed_in? && current_user.admin?
      "<li class='dropdown'>
          <a href='#' class='dropdown-toggle' data-toggle='dropdown' role='button' aria-expanded='false'>Admin Section <span class='caret'></span></a>
          <ul class='dropdown-menu' role='menu'>

          <li>#{link_to 'All Deals', admin_deals_path}</li>
            <li class='divider'></li>
            <li>#{link_to 'All Orders', admin_orders_path}</li>
            <li class='divider'></li>
          </ul>
        </li>".html_safe
    end
  end
end
