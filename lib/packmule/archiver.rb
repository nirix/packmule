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
          # Zipit, zipit good
          Packmule::Archiver::Zip.create(options)
        elsif format == 'tar'
          # TARzan
          Packmule::Archiver::Tar.create(options)
        elsif format == 'tar.gz'
          # Targz, klingon pets
          Packmule::Archiver::Tar.create(options.merge({:gzip => true}))
        elsif format == 'tar.bz2'
          # Tarbz2, I got nothing...
          Packmule::Archiver::Tar.create(options.merge({:bzip => true}))
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
          puts "#{options[:filename]}.zip already exists, skipping"
          return false
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
        return true
      end # self.create
    end # Zip class
    
    ##
    # Tar
    class Tar
      ##
      # Creates the tar file, like a BOSS!
      def self.create(options)
        options = {:gzip => false, :bzip => false}.merge(options)
        filename = "#{options[:filename]}.tar" + (options[:gzip] ? '.gz' : (options[:bzip] ? '.bz2' : ''))
        
        # Make sure it doesn't exist..
        if ::FileTest.exists? "./#{filename}"
          puts "#{filename} already exists, skipping"
          return false
        end
        
        if options[:gzip] == true
          # Tar and gzip like a boss
          `tar czf #{filename} #{options[:dir]}`
          puts " - #{filename} created"
        elsif options[:bzip] == true
          # Bzippit
          `tar cfj #{filename} #{options[:dir]}`
          puts " - #{filename} created"
        else
          # Totally boss taring code, yo
          `tar cf #{filename} #{options[:dir]}`
          puts " - #{filename} created"
        end
        
        return true
      end # self.create
    end # Tar
  end # Archiver
end