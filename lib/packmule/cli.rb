#
# PackMule
# Copyright (c) 2012 Nirix
# All Rights Reserved
#

require 'shebang'

module PackMule
  module CLI
    module Commands
      class Default < ::Shebang::Command
        command :default
        banner 'PackMule makes packaging project archives easy.'
        usage 'packmule [command] [options]'

        o :v, :version, 'Shows PackMules version', :method => :_version
        o :p, :pack, 'Packs the project, example: packmule pack --ver 1.2.3-beta', :method => :pack
        o :nil, :ver, 'Package archive version', :type => String, :default => ''

        def index
          help
        end

        ##
        # Displays the gem version.
        def _version
          puts PackMule::VERSION
          exit
        end

        ##
        # Packs the project according to the PackMule file.
        def pack
          require 'yaml'

          # Read the PackMule file and exit if it doesn't exist
          puts "Reading PackMule file..."
          begin
            config = YAML::load_file('./PackMule')
          rescue
            puts "No PackMule file found, stopping"
            exit;
          end

          # Create the archive name
          archive_name = config['package-as'] + (option(:ver) != '' ? '-' + option(:ver) : '')

          # Check the format, currently only .zip
          if config['format'] == 'zip'
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
            end # Zip
          end # format == zip

          puts "Done, #{archive_name} created"
          exit
        end
      end
    end
  end
end