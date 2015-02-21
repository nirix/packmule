#
# Packmule
# Copyright (c) 2012-2015 Nirix
# https://github.com/nirix
#
# Packmule is released under
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
  end # Archiver
end
