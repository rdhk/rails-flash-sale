namespace :users do
  #FIXME_AB: - done
  desc "generating auth token for verified users"
  task generate_auth_token: :environment do
    users = User.verified #FIXME_AB: verified only - done
    users.each do |user|
      user.generate_token_and_save(:auth_token)
    end

  end

end
