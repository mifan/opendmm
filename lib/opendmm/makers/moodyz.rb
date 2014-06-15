module OpenDMM
  module Maker
    module Moodyz
      include Maker

      module Site
        include HTTParty
        base_uri 'moodyz.com'

        def self.item(name)
          case name
          when /(MIAD|MIDD|MIDE|MIGD|MIMK|MINT|MIQD|MIRD|MIXS)-?(\d{3})/i
            $alpha = $1.downcase
            $alpha.remove!(/d$/) if ( ($alpha == 'midd' && $2.to_i <= 643) ||
                                      ($alpha == 'migd' && $2.to_i <= 336) ||
                                      ($alpha == 'mird' && $2.to_i <= 72) )
            get("/shop/-/detail/=/cid=#{$alpha}#{$2}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          specs = Utils.hash_by_split(html.xpath('//*[@id="nabi_information"]/ul/li[1]/dl/dd').map(&:text)).merge(
                  Utils.hash_by_split(html.xpath('//*[@id="nabi_information"]/ul/li').map(&:text)[1..-1]))
          return {
            actresses:       html.xpath('//*[@id="works"]/dl/dt').map(&:text),
            code:            specs['品番'],
            cover_image:     html.xpath('//*[@id="works"]/span/a/p/img').first['src'].gsub(/pm.jpg$/, 'pl.jpg'),
            description:     html.xpath('//*[@id="works"]/dl/dd').text,
            directors:       specs['▪監督'].split,
            genres:          specs['▪ジャンル'].split('/'),
            label:           specs['▪レーベル'],
            movie_length:    specs['収録時間'],
            page:            page_uri.to_s,
            release_date:    specs['発売日'],
            sample_images:   html.xpath('//*[@id="sample-pic"]/li/a/img').map { |img| img['src'].gsub(/js(?=-\d+\.jpg$)/, 'jp') },
            series:          specs['▪シリーズ'],
            thumbnail_image: html.xpath('//*[@id="works"]/span/a/p/img').first['src'],
            title:           html.xpath('//*[@id="main"]/ul[2]/h3/dl/dd/h2').text,
          }
        end
      end
    end
  end
end