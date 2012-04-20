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
    def self.create(options)
      puts "Creating archives..."
      
      options[:formats].each do |format|
        if format == 'zip'
          Packmule::Archiver::Zip.create(options)
        end
      end
      
      puts "Done creating archives"
    end
    
    ##
    # Zipper
    class Zip
      ##
      # Zips the stuff
      def self.create(options)
        # Make sure the archive doesn't exist..
        if ::FileTest.exists? "./#{options[:filename]}.zip"
          puts "#{options[:filename]}.zip already exists, stopping"
          exit
        end

        # Get the needed Zip stuff
        gem 'rubyzip'
        require 'zip/zip'
        require 'zip/zipfilesystem'

        # Create the archive
        ::Zip::ZipFile.open("./#{options[:filename]}.zip", 'w') do |z|
          Dir["#{options[:dir]}/**/**"].each do |file|
            z.add(file.sub("#{options[:dir]}/", ''), file) if not options[:ignore].include?(file.sub("#{options[:dir]}/", ''))
          end # Dir
        end # Zip block
        
        puts "  - #{options[:filename]}.zip created"
      end # Archive
    end # Zip class
  end # Archiver
end