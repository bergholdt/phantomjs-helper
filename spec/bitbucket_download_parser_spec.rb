require "spec_helper"

describe Phantomjs::Helper::BitbucketDownloadParser do
  let!(:open_uri_provider) do
    double("open_uri_provider").tap do |oup|
      allow(oup).to receive(:open_uri) { File.read(File.join(File.dirname(__FILE__), "assets/bitbucket_downloads.html")) }
    end
  end
  let!(:parser) { Phantomjs::Helper::BitbucketDownloadParser.new(/phantomjs-.*-windows/,
                                                               url: Phantomjs::Helper::BUCKET_URL,
                                                               open_uri_provider: open_uri_provider) }

  describe "#downloads" do
    it "returns an array of URLs for the platform" do
      expect(parser.downloads).to eq [
        'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip',
        'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-windows.zip',
        'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-windows.zip',
        'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-windows.zip',
        'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.6-windows.zip'
      ]
    end
  end

  describe "#newest_download" do
    it "returns the last URL for the platform" do
      expect(parser.newest_download).to eq 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip'
    end

    context "out-of-order versions" do
      before do
        allow(parser).to receive(:downloads).and_return([
          'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-windows.zip',
          'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-windows.zip',
          'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-windows.zip',
          'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip',
          'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.6-windows.zip'
          ])
      end

      it "returns the newest version" do
        expect(parser.newest_download).to eq 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip'
      end
    end
  end
end
