# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
url = 'https://www.google.com/search?q=celestron+c8'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# href抜き出し
nodes = doc.xpath('//div[@class="kCrYT"]/a')

nodes.each do |node|
  if node[:href].include?('vixen') or node[:href].include?('syumitto') then
    puts node[:href][/=(.*?)&/, 1]
  end
end