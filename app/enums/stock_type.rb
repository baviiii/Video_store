##
# Enum definition for role of user
class StockType < ClassyEnum::Base
end
##
#
class StockType::Digital < StockType
end

class StockType::BlueRay < StockType
end

class StockType::VHS < StockType
end

class StockType::DVD < StockType
end
