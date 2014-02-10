#
# Packmule
# Copyright (c) 2012-2014 Nirix
# All Rights Reserved
# https://github.com/nirix
#
# Packmule is released under
# the GNU GPL v3 only license.
#

require "packmule/version"
require "packmule/archiver"

module Packmule
  ##
  # The center of Packmule, takes the Packfile
  # and packs the directory according to the options.
  def self.pack(options)
    require 'yaml'
    require 'fileutils'
    require 'tmpdir'

    tempdir = Dir.mktmpdir

    # Read the Packfile and exit if it doesn't exist
    puts "Reading the Packfile..."
    begin
      config = YAML::load_file('./Packfile')
    rescue
      puts "No Packfile found, stopping"
      exit;
    end

    # Options
    opt = {
      :filename => config['package-as'] + (options[:version] != '' ? '-' + options[:version] : ''),
      :formats  => config['formats'],
      :version  => options[:version],
      :ignore   => config['ignore'],
      :commands => config['commands']
    }

    # Clone directory
    ::FileUtils.cp_r './', tempdir

    # Any commands?
    if opt[:commands]
      self.run_commands tempdir, opt[:commands]
    end

    # Remove ignored files and directories
    opt[:ignore].each do |badness|
      ::FileUtils.rm_rf Dir["#{tempdir}/#{badness}"], :secure => true
    end

    # Archive the directory
    Packmule::Archiver.create({
      :filename => opt[:filename],
      :formats  => opt[:formats],
      :ignore   => opt[:ignore],
      :dir      => tempdir
    })

    # Cleanup
    FileUtils.remove_entry_secure tempdir

    puts "Packaging complete"
    exit
  end

  ##
  # Runs the specified commands in the specified directory.
  def self.run_commands(dir, commands)
    commands.each do |c|
      # Change to tempdir and run
      `cd #{dir}; #{c}`
    end
  end
end
