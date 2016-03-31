Entry.destroy_all

30.times do |n|
  Entry.create!(title: "#{n}番目のタイトル", content: "#{n}番目の本文 #{SecureRandom.uuid}")
end