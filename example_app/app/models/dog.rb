require_relative "toy"

class Dog < ModelBase
  finalize!

  has_many :toys
end
