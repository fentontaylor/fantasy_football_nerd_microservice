class Key < ActiveRecord::Base
  validates_presence_of :value
  enum access_type: { open: 0, admin: 1 }
end
