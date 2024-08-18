##
# Enum definition for role of user
class AdminRole < ClassyEnum::Base
end
##
#
class AdminRole::SuperUser < AdminRole
end

class AdminRole::AdminUser < AdminRole
end

class AdminRole::NormalUser < AdminRole
end
class AdminRole::Customer < AdminRole
end
