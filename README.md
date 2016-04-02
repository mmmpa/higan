# 彼岸

彼岸は特定のモデルをHTML化してFTPにアップロードするためのRailsエンジンです。

# できあがり

`:entry`として設定したエレメント郡を`:main_host`として設定したFTPサーバーにアップロードする。

```
Higan.upload(:entry).to(:main_host)
```

# インストール

あとで書く

# おおまかな設定

`initializers/higa.rb`などに。

```
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
```

## add_ftp

見てのとおり。

## add_element

`klass.send(scope)`で取得できるエレメント郡を`each`でrenderする。

`template`か`renderer`を設定する。

### `template`では以下のようにrenderする。

```
view = ActionView::Base.new(ActionController::Base.view_paths, {})
view.assign({record: record})
view.render(file: file)
```

お好きなテンプレートエンジンで書く。

```
<h1><%= @record.title %></h1>
<p><%= @record.content %></p>
```

### `renderer`では`Proc`類を渡されることを期待している。

```
->(record) {
%{
<h1>#{record.title}</h1>
<p>#{record.content}</p>
}
```

# 手順

- エレメント郡を用意
- `Higan::write_temp(エレメント郡名)`でローカルファイルを用意
- `Higan.upload(エレメント郡名).to(FTP名)`でアップロード

# その他

## `Higan.test_ftp(FTP名)`

つながるかテスト。`true`か`false`か`ftp`モジュールの例外が返る。

## `Higan.test_uploading(:main_host)`

`base_dir`にダミーディレクトリを作成する。