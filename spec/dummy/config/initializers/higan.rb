require 'higan'

Higan.configure do
  local {
    temp_dir "#{Rails.root}/tmp/higan"
  }

  ftp {
    host ENV['HIGAN_HOST']
    user ENV['HIGAN_USER']
    password ENV['HIGAN_PASSWORD']
    base_dir '/public_html'
    mode :binary
  }

  default {
    public true
  }

  add {
    klass Entry
    scope :all
    path ->(entry) { "/entry/#{entry.title}.html" }
    template "#{Rails.root}/app/views/entries/show.html.erb"
  }
end

Higan.write_temp