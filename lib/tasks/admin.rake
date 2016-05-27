namespace :admin do
  desc "making an admin"
  task new: :environment do
    user = User.new
    user.admin = true
    puts "Hi Admin, Please enter your first name"
    user.first_name = STDIN.gets.strip

    puts "Please enter your last name"
    user.last_name = STDIN.gets.strip

    puts "Please enter your email"
    user.email = STDIN.gets.strip

    puts "Please enter your password"
    user.password = STDIN.gets.strip

    puts "Please enter your password again"
    user.password_confirmation = STDIN.gets.strip

    user.verified_at = Time.current

    if(user.save)
      puts "Admin #{user.email} has been successfully created."
    else
      user.errors.full_messages.each do |msg|
        puts msg
      end
    end

  end

end
