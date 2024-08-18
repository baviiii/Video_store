# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def movie_back_in_stock(user, movie)
    @user = user
    @movie = movie

    mail(to: @user.email, subject: "Your requested video is back in stock!")
  end
end
