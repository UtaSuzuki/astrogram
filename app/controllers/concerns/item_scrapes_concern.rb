module ItemScrapesConcern
  # URLにアクセスするためのライブラリの読み込み
  require 'open-uri'
  # Nokogiriライブラリの読み込み
  require 'nokogiri'

  def set_item_link(item="A80Mf")
    if item.length <= 0 then
      return
    end
    item = item.tr(" 　", "++")  # 半角/全角スペースを"+"に置換
    # 検索文字の日本語対応 : URI.encode
    # スクレイピング先 (Google検索エンジン)
    url = 'https://www.google.com/search?q=' + item
    if url =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/ then
      url = URI.encode url
    end

    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    # ターゲットサイト名
    targetECsites = ['amazon', 'rakuten', 'yahoo', 'vixen', 'syumitto', 'kyoei', 'tomytec']
    
    # 出力要素初期化
    iLink = 0
    scrapedLinks = ''
    scrapedSites = ''

    # href抜き出し
    targetECsites.each do |site|
      # Google検索エンジンで検索結果ページスクレイピング時、各リンクのdivクラス：kCrYT
      doc.xpath('//div[@class="kCrYT"]/a').each do |node|
        if node[:href].include?('.' + site) then
          iLink = iLink + 1
          siteLink = node[:href][/=(.*?)&/, 1]
          scrapedSites = scrapedSites + "," + site
          if siteLink.include?('%2B') then
            siteLink = siteLink.gsub(/%2B/, '+')
          end
          if site == 'yahoo' then
            siteLink = siteLink.gsub(/%25/, '%')
          end
          scrapedLinks = scrapedLinks + "," + siteLink    # 最初の"="から最初の"&"までを抜き出し
          break
        end
      end
    end
    
    # 出力形式 : nLink, site1name, site2name, ... , site1URL, site2URL, ...
    return iLink.to_s + scrapedSites + scrapedLinks
  end
end