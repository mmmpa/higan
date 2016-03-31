require 'higan'

Higan.configure do
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

pp Higan.render_test