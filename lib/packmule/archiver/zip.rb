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
        require 'zip'

        # Create the archive
        ::Zip::File.open("./#{options[:filename]}.zip", 'w') do |z|
          Dir["#{options[:dir]}/**/**"].each do |file|
            z.add(file.sub("#{options[:dir]}/", ''), file) if not options[:ignore].include?(file.sub("#{options[:dir]}/", ''))
          end # Dir
        end # Zip block

        puts " - #{options[:filename]}.zip created"
        return true
      end # self.create
    end # Zip
  end
end
