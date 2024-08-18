module UsersDashboard::MoviesHelper
  def star_rating(rating)
    full_stars = rating.floor
    half_star = (rating - full_stars >= 0.5) ? 1 : 0
    empty_stars = 5 - full_stars - half_star

    '★' * full_stars + '½' * half_star + '☆' * empty_stars
  end
end
