class Entry < ActiveRecord::Base
  scope :target, -> { where { id < 15 } }

  def test
    :test
  end
end
