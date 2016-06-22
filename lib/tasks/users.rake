namespace :users do
  desc "making an admin"
  task generate_auth_token: :environment do
    users = User.all
    users.each do |user|
      user.generate_token_and_save(:auth_token)
    end

  end

end
