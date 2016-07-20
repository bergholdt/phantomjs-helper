require 'nokogiri'
require 'open-uri'
require 'openssl'

module Phantomjs
  class Helper
    class BitbucketDownloadParser

      attr_reader :source, :driver_name, :url

      def initialize(driver_name, url:, open_uri_provider: OpenURI)
        @driver_name = driver_name
        @url = url
        @source = open_uri_provider.open_uri(url, {:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE})
      end

      def downloads
        doc = Nokogiri::XML.parse(source)
        items = doc.css('table#uploaded-files tr.iterable-item td.name a.execute').collect {|k| {text:k.text, url:k[:href]} }
        items.reject! {|k| !(driver_name===k[:text]) }
        items.map {|k| URI.parse(url).tap {|u|u.path = k[:url]}.to_s}
      end

      def newest_download
        (downloads.sort { |a, b| version_of(a) <=> version_of(b)}).last
      end

      private

      def version_of(url)
        Gem::Version.new grab_version_string_from(url)
      end

      def grab_version_string_from(url)
        url.match(/-(\d+\.?\d+\.?\d+)\-/).captures.first
      end
    end
  end
end
