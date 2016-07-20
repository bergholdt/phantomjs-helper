require 'fileutils'

module Phantomjs
  class Extractor
    class << self
      def extract(archive_file, destination)
        case File.extname(archive_file)
          when '.zip'
            extract_zip(archive_file, destination)
          when '.bz2'
            extract_bz2(archive_file, destination)
          else
            raise "Do not know how to extract binary from #{archive_file}"
        end
      end

      private

      def extract_zip(archive_file, destination)
        require 'zip'
        Zip::File.open(archive_file) do |zip_file|
          entry = zip_file.glob('**/bin/phantomjs*').first
          raise "Could not find phantomjs binary in zip archive #{archive_file}" unless entry
          FileUtils.rm_f destination
          entry.extract(destination)
        end
      end

      def extract_bz2(archive_file, destination)
        require 'ffi-libarchive'
        Archive.read_open_filename(archive_file) do |ar|
          ar.each_entry do |e|
            if e.pathname.include?('bin/phantomjs')
              File.open(destination, 'wb') do |saved_file|
                saved_file.write(ar.read_data)
              end
              return
            end
          end
        end
        raise "Could not find phantomjs binary in archive #{archive_file}"
      end
    end

  end
end
