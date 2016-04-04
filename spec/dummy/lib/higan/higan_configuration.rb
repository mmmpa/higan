class HiganConfiguration
  include Higan::Configurator

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
    scope :target
    path ->(entry) { "/entry/#{entry.id}.html" }
    template "#{Rails.root}/app/views/entries/show.html.erb"
  end

  add_element :index do
    klass Entry
    path ->(s) { '/entry/index.html' }
    template "#{Rails.root}/app/views/entries/index.html.slim"
  end


  add_file :css do
    files Dir[Rails.root.join('public', '**', '*.{html}').to_s]
    base_dir Rails.root.join('public')
    dir '/css'
  end
end