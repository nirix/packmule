#
# PackMule
# Copyright (c) 2012 Nirix
# All Rights Reserved
#
# PackMule is released under
# the GNU GPL v3 only license.
#

module Packmule
  module Archiver
    ##
    # Archives the shit out of the directory
    # with the passed options.
    def archive(options)
      # blarglolz
    end
    
    ##
    # Zipper
    class Zip
      ##
      # Zips the stuff
      def archive(options)
        # Make sure the archive doesn't exist..
        if FileTest.exists? "./#{archive_name}.zip"
          puts "#{archive_name}.zip already exists, stopping"
          exit
        end

        # Get the needed Zip stuff
        puts "Creating zip archive"
        gem 'rubyzip'
        require 'zip/zip'
        require 'zip/zipfilesystem'

        # Create the archive
        Zip::ZipFile.open("./#{archive_name}.zip", 'w') do |z|
          Dir["./**/**"].each do |file|
            z.add(file.sub("./", ''), file) if not config['ignore'].include?(file.sub('./', ''))
          end # Dir
        end # Zip block
      end # Archive
    end # Zip class
  end # Archiver
end