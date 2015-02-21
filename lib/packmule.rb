#
# Packmule
# Copyright (c) 2012-2015 Nirix
# https://github.com/nirix
#
# Packmule is released under
# the GNU GPL v3 only license.
#

require "packmule/version"
require "packmule/archiver"
require "packmule/archiver/zip"
require "packmule/archiver/tar"

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
    config = self.read_packfile

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
    if opt[:ignore]
      self.remove_files tempdir, opt[:ignore]
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
  # Reads configuration from the `Packfile`
  def self.read_packfile
    begin
      config = YAML::load_file('./Packfile')
    rescue
      puts "No Packfile found, stopping"
      exit;
    end
  end

  ##
  # Runs the specified commands in the specified directory.
  def self.run_commands(dir, commands)
    commands.each do |c|
      # Change to tempdir and run
      `cd #{dir}; #{c}`
    end
  end

  ##
  # Removes the specified files from the specified directory.
  def self.remove_files(dir, files)
    files.each do |file|
      ::FileUtils.rm_rf Dir["#{dir}/#{file}"], :secure => true
    end
  end
end
