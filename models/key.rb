class Key < ActiveRecord::Base
  enum access_type: { open: 0, admin: 1 }
end
