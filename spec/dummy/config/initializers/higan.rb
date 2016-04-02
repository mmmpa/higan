require 'higan'

Higan.configure do
  base {
    temp_dir "#{Rails.root}/tmp/higan"
    public true
  }

  add_ftp :main_host do
    host ENV['HIGAN_HOST']
    user ENV['HIGAN_USER']
    password ENV['HIGAN_PASSWORD']
    base_dir '/public_html'
    mode :binary
  end

  add_element :entry do
    klass Entry
    scope :all
    path ->(entry) { "/entry/#{entry.id}.html" }
    template "#{Rails.root}/app/views/entries/show.html.erb"
  end
end

p Higan
pp Higan.write_temp(:entry)
#p Higan.test_ftp(:main_host)
#p Higan.test_uploading(:main_host)
#p Higan.upload(:entry)
pp Higan.upload(:entry).to(:main_host)