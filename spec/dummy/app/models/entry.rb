class Entry < ActiveRecord::Base
  scope :target, -> { order { id.desc } }

  def test
    :test
  end
end
