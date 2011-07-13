#!/usr/bin/env ruby

# Dumb-ass Daily Backup - A stupid backup script inspired by some other stupid php script I had lying around
# 
# A backup directory will be created within the destination directory for each key of the sources hash.
# Values can be files, directories or glob patterns.
# Directories will be backed up as gzipped tar archives, text files are gzipped, binary files are copied.
# Create a /etc/dumb_ass_daily_backup.yml config file to override the default sources and destination.
# Nothing fancy, no incremental backups, no syncing to remote servers, just a dumb backup script.

require 'yaml'
require 'fileutils'

config = File.exist?("/etc/dumb_ass_daily_backup.yml") ? YAML::load_file("/etc/dumb_ass_daily_backup.yml") : {}

sources = config['sources'] || {
  "etc" => "/etc/"
}

destination = config['destination'] || "/srv/backup/daily/"

today = Time.now.strftime('%A').downcase

sources.each do |name, glob_pattern|

  backup_path = File.join(destination, today, name) 
  FileUtils.mkdir_p(backup_path)
  puts "\n#{name}: backing up #{glob_pattern} to #{backup_path}"

  Dir.glob(glob_pattern).each do |path|
    
    print "* #{File.basename(path)} -> "
    if File.directory?(path)
      # directory, tar and gzip it
      backup_file_path = File.join(backup_path, "#{File.basename(path)}.tar.gz")
      system("tar -zpc \"#{path}\" > \"#{backup_file_path}\" 2> /dev/null")
    elsif `file -b "#{path}"`.include?('text')
      # looks like a text file, gzip it
      backup_file_path = File.join(backup_path, "#{File.basename(path)}.gz")
      system("gzip -c \"#{path}\" > \"#{backup_file_path}\"")
    else
      # seems to be a binary, just copy it
      backup_file_path = File.join(backup_path, File.basename(path))
      system("cp \"#{path}\" \"#{backup_file_path}\"")
    end
    print "#{backup_file_path}\n"

  end
  
end
