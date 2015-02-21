# -*- ruby -*-
 
require 'rubygems'
require 'hoe'
require './lib/mturk/version.rb'

Hoe.spec 'mturk' do
  self.version = MTurk::VERSION.dup
  developer 'David J Parrott', 'valthon@nothlav.net'
  license 'APLv2'
  extra_deps << ['highline','>= 1.2.7']
  extra_deps << ['nokogiri','>= 1.4']
  need_tar
  need_zip

  self.summary = 'Ruby libraries for working with Mechanical Turk'
  self.email = 'requester@mturk.com'
  self.urls = ["https://requester.mturk.com/"]
end

task :gitversion do
  gv = `git describe --dirty`.chomp.gsub(/^v/,'').gsub('-','.')
  File.open('lib/mturk/version.rb', File::WRONLY | File::CREAT | File::TRUNC ) do |f|
    f << "# Copyright:: Copyright (c) 2007-2015 Amazon Technologies, Inc.\n"
    f << "# License::   Apache License, Version 2.0\n"
    f << "\n"
    f << "module MTurk\n"
    f << "  VERSION = '#{gv}'.freeze\n"
    f << "end\n"
  end
end

# vim: syntax=ruby
