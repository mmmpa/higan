class Entry < ActiveRecord::Base
  scope :target, -> { where { id < 15 }.order { id.desc } }

  def test
    :test
  end
end
