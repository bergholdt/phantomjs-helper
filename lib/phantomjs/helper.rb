require 'phantomjs/helper/version'
require 'phantomjs/helper/bitbucket_download_parser'
require 'fileutils'
require 'rbconfig'
require 'open-uri'
require 'zip'
require 'ffi-libarchive'

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
          URI.parse(url).open('rb') do |read_file|
            saved_file.write(read_file.read)
          end
        end
        raise "Could not download #{url}" unless File.exists? filename
        extract filename
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

    def extract(filename)
      case File.extname(filename)
        when '.zip'
          Zip::File.open(filename) do |zip_file|
            entry = zip_file.glob('**/bin/phantomjs*').first
            raise "Could not find phantomjs binary in zip archive #{filename}" unless entry
            FileUtils.rm_f entry.name
            entry.extract(File.basename(entry.name))
          end
        when '.bz2'
          Archive.read_open_filename(filename) do |ar|
            ar.each_entry do |e|
              if e.pathname.include?('bin/phantomjs')
                File.open(binary_path, 'wb') do |saved_file|
                  saved_file.write(ar.read_data)
                end
              end
            end
          end
        else
          raise "Do not know how to extract binary from #{filename}"
      end
    end

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
