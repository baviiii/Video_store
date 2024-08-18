##
# Enum definition for role of user
class ContentRating < ClassyEnum::Base
  def self.to_human
    map { |enum| [enum.value, enum.to_s.gsub('ContentRating::', '').titleize] }.to_h
  end
end
##
#
class ContentRating::PG_rated < ContentRating
end

class ContentRating::R_rated < ContentRating
end

class ContentRating::PG13 < ContentRating
end
class ContentRating::G_rated < ContentRating
end
