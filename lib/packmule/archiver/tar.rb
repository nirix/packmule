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
    # Tar
    class Tar
      ##
      # Creates the tar file, like a BOSS!
      def self.create(options)
        options = {:gzip => false, :bzip => false, :xz => false}.merge(options)
        filename = "#{options[:filename]}.tar" + (options[:gzip] ? '.gz' : (options[:bzip] ? '.bz2' : (options[:xz] ? '.xz' : '')))

        # Make sure it doesn't exist..
        if ::FileTest.exists? "./#{filename}"
          puts "#{filename} already exists, skipping"
          return false
        end

        if options[:gzip] == true
          # Tar and gzip like a boss
          `tar czf #{filename} -C #{options[:dir]} ./`
        elsif options[:bzip] == true
          # Bzippit
          `tar cfj #{filename} -C #{options[:dir]} ./`
        elsif options[:xz] == true
          `tar cf - -C #{options[:dir]} ./ | xz -zf - > #{filename}`
        else
          # Totally boss taring code, yo
          `tar cf #{filename} -C #{options[:dir]} ./`
        end

        if ::FileTest.exists? "./#{filename}"
          puts " - #{filename} created"
        end

        return true
      end # self.create
    end # Tar
  end
end
