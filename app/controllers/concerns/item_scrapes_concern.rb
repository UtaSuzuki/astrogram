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
    url = 'https://www.google.com/search?q=' + item  # スクレイピング先

    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    iLink = 0
    scrapedLinks = ''
    scrapedSites = ''
    targetECsites = ['amazon', 'rakuten', 'yahoo', 'vixen', 'syumitto', 'kyoei', 'tomytec']

    # href抜き出し
    # 購入サイト候補：vixen, syumitto, kyoei-tokyo, amazon, rakuten, tomytec
    targetECsites.each do |site|
      doc.xpath('//div[@class="kCrYT"]/a').each do |node|
        if node[:href].include?(site) then
          iLink = iLink + 1
          scrapedSites = scrapedSites + "," + site
          scrapedLinks = scrapedLinks + "," + node[:href][/=(.*?)&/, 1]
          break
        end
      end
    end
    return iLink.to_s + scrapedSites + scrapedLinks
  end
end