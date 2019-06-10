module UsersHelper

  def status_icon(user)
    user_confirmed = user.confirmed? ? 'table_main__user-confirmed' : 'table_main__user-unconfirmed'
    icon = user.active ? user_confirmed : 'table_main__user-disabled'
    "<span class='#{ icon }'></span>"
  end
end
