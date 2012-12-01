#
# Packmule
# Copyright (c) 2012 Nirix
# All Rights Reserved
# https://github.com/nirix
#
# Packmule is released under
# the GNU GPL v3 only license.
#

require 'shebang'

module Packmule
  ##
  # CLI stuff
  module CLI
    ##
    # CLI Commands
    module Commands
      ##
      # Default commands
      class Default < ::Shebang::Command
        command :default
        banner 'Packmule makes packaging project archives easy.'
        usage 'packmule [command] [options]'

        o :v, :version, 'Shows Packmule\'s version', :method => :_version

        def index
          help
        end

        ##
        # Displays the gem version.
        def _version
          puts Packmule::VERSION
          exit
        end
      end

      ##
      # Pack command
      class Pack < ::Shebang::Command
        command :pack
        banner 'Reads the Packfile and packages the directory.'
        usage 'packmule pack -v 1.2.3-beta2'

        o :v, :version, 'Version of the archive', :type => :string, :default => ''

        def index
          Packmule.pack :version => option(:version)
        end
      end
    end
  end
end