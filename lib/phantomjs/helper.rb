require 'phantomjs/helper/version'
require 'phantomjs/helper/bitbucket_download_parser'
require 'phantomjs/helper/extractor'
require 'fileutils'
require 'rbconfig'
require 'open-uri'
require 'openssl'

module Phantomjs
  class Helper
    BUCKET_URL = 'https://bitbucket.org/ariya/phantomjs/downloads'

    def run(*args)
      download
      exec binary_path, *args
    end

    def update
      download true
    end

    def download(hit_network=false)
      return if File.exists?(binary_path) && !hit_network
      url = download_url
      filename = File.basename url
      FileUtils.mkdir_p install_dir
      Dir.chdir install_dir do
        FileUtils.rm_f filename
        File.open(filename, 'wb') do |saved_file|
          URI.parse(url).open('rb',{:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE}) do |read_file|
            saved_file.write(read_file.read)
          end
        end
        raise "Could not download #{url}" unless File.exists? filename
        Extractor.extract(filename, binary_path)
        FileUtils.rm_f filename
      end
      raise "Could not unzip #{filename} to get #{binary_path}" unless File.exists? binary_path
      FileUtils.chmod 'ugo+rx', binary_path
    end

    def remove
      FileUtils.rm binary_path
    end

    def binary_path
      if platform == 'windows'
        File.join install_dir, 'phantomjs.exe'
      else
        File.join install_dir, 'phantomjs'
      end
    end

    private 

    def driver_name
      /phantomjs-.*-#{platform}/
    end

    def download_url
      BitbucketDownloadParser.new(driver_name, url: BUCKET_URL).newest_download
    end

    def install_dir
      File.expand_path File.join(home_dir, '.phantomjs-helper', platform)
    end

    def platform
      case RbConfig::CONFIG['host_os']
        when /linux/ then
          RbConfig::CONFIG['host_cpu'] =~ /x86_64|amd64/ ? 'linux-x86_64' : 'linux-i686'
        when /darwin/ then
          'macosx'
        else
          'windows'
      end
    end

    def home_dir
      ENV['HOME']
    end

  end
end
