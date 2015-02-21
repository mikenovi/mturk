# Copyright:: Copyright (c) 2007 Amazon Technologies, Inc.
# License::   Apache License, Version 2.0

require 'test/unit'
require 'mturk'

class TestMTurk < Test::Unit::TestCase

  VERSION_NUMBER_PATTERN = '\d+\.\d+\.\d+(\.[a-zA-Z\d]+)*'

  def testVersion
    assert( MTurk::VERSION =~ /^#{VERSION_NUMBER_PATTERN}$/ , "MTurk::VERSION is incorrectly formatted")
  end

  def testAgent
    assert( MTurk.agent =~ /^ruby-mturk\/#{VERSION_NUMBER_PATTERN}$/ )
    assert( MTurk.agent('Tester') =~ /^ruby-mturk\/#{VERSION_NUMBER_PATTERN} Tester$/ )
  end

end

