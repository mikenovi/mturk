# Copyright:: Copyright (c) 2007-2014 Amazon Technologies, Inc.
# License::   Apache License, Version 2.0

require 'test/unit/testcase'
require 'mturk'
require 'amazon/webservices/util/mock_transport'
require 'timeout'
require 'amazon/webservices/util/validation_exception'

class TestErrorHandler < Test::Unit::TestCase
  RETRYABLE_ATTEMPT_COUNT = 7

  def setup
    @mock = Amazon::WebServices::Util::MockTransport.new
    @mturk = Amazon::WebServices::MechanicalTurkRequester.new( :Transport => @mock, :AWSAccessKey => 'bogus', :AWSAccessKeyId => 'fake' )
  end

  def testTimeoutOnceRetryable
    # mock will timeout first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      Timeout.timeout(1) do
        if should_fail
          should_fail = false
          sleep(2)
        end
      end
      nil
    end

    # invoke a retryable call once, should auto-retry and return success
    @mturk.getAccountBalance
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GetAccountBalance, call.name, "Should have been a GetAccountBalance call" }
  end

  def testTimeoutOnceNotRetryable
    # mock will timeout first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      Timeout.timeout(1) do
        if should_fail
          should_fail = false
          sleep(2)
        end
      end
      nil
    end

    # invoking a non-retryable call will throw an exception
    begin
      @mturk.grantBonus
      fail "Should have thrown an exception"
    rescue Timeout::Error
      # expect this exception
    end
    assert_equal :GrantBonus, @mock.next.name
    assert_nil @mock.next
  end

  def testTimeoutOnceRetryableUniqueRequestToken
    # mock will timeout first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      Timeout.timeout(1) do
        if should_fail
          should_fail = false
          sleep(2)
        end
      end
      nil
    end

    # invoke call with an idempotency once, should auto-retry and return success
    @mturk.grantBonus :UniqueRequestToken => 'UniqueTokenValue'
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GrantBonus, call.name, "Should have been a GrantBonus call" }
  end

  def testTimeoutAlways
    #mock will always timeout
    @mock.listen do |call|
      Timeout.timeout(1) { sleep(2) }
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue Timeout::Error
      # expect this exception
    end

    RETRYABLE_ATTEMPT_COUNT.times do
      assert_equal :SearchHITs, @mock.next.name
    end
    assert_nil @mock.next
  end

  def testResetConnectionOnceRetryable
    # mock will reset connection first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Errno::ECONNRESET
      end
      nil
    end

    # invoke a retryable call once, should auto-retry and return success
    @mturk.getAccountBalance
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GetAccountBalance, call.name, "Should have been a GetAccountBalance call" }
  end

  def testResetConnectionOnceNotRetryable
    # mock will reset connection first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Errno::ECONNRESET
      end
      nil
    end

    # invoking a non-retryable call will throw an exception
    begin
      @mturk.grantBonus
      fail "Should have thrown an exception"
    rescue Errno::ECONNRESET
      # expect this exception
    end
    assert_equal :GrantBonus, @mock.next.name
    assert_nil @mock.next
  end

  def testResetConnectionOnceRetryableUniqueRequestToken
    # mock will reset connection first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Errno::ECONNRESET
      end
      nil
    end

    # invoke call with an idempotency once, should auto-retry and return success
    @mturk.grantBonus :UniqueRequestToken => 'UniqueTokenValue'
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GrantBonus, call.name, "Should have been a GrantBonus call" }
  end

  def testResetConnectionAlways
    #mock will always reset connection
    @mock.listen do |call|
      raise Errno::ECONNRESET
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue Errno::ECONNRESET
      # expect this exception
    end

    RETRYABLE_ATTEMPT_COUNT.times do
      assert_equal :SearchHITs, @mock.next.name
    end
    assert_nil @mock.next
  end

  def testPipeBrokenOnceRetryable
    # mock will break pipe first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Errno::EPIPE
      end
      nil
    end

    # invoke a retryable call once, should auto-retry and return success
    @mturk.getAccountBalance
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GetAccountBalance, call.name, "Should have been a GetAccountBalance call" }
  end

  def testPipeBrokenOnceNotRetryable
    # mock will break pipe first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Errno::EPIPE
      end
      nil
    end

    # invoking a non-retryable call will throw an exception
    begin
      @mturk.grantBonus
      fail "Should have thrown an exception"
    rescue Errno::EPIPE
      # expect this exception
    end
    assert_equal :GrantBonus, @mock.next.name
    assert_nil @mock.next
  end

  def testPipeBrokenOnceRetryableUniqueRequestToken
    # mock will reset connection first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Errno::EPIPE
      end
      nil
    end

    # invoke call with an idempotency once, should auto-retry and return success
    @mturk.grantBonus :UniqueRequestToken => 'UniqueTokenValue'
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GrantBonus, call.name, "Should have been a GrantBonus call" }
  end

  def testPipeBrokenAlways
    #mock will always break pipe
    @mock.listen do |call|
      raise Errno::EPIPE
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue Errno::EPIPE
      # expect this exception
    end

    RETRYABLE_ATTEMPT_COUNT.times do
      assert_equal :SearchHITs, @mock.next.name
    end
    assert_nil @mock.next
  end

  def testServiceUnavailableOnceRetryable
    # mock will break pipe first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Amazon::WebServices::Util::ValidationException.new(nil, 'AWS.ServiceUnavailable')
      end
      nil
    end

    # invoke a retryable call once, should auto-retry and return success
    @mturk.getAccountBalance
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GetAccountBalance, call.name, "Should have been a GetAccountBalance call" }
  end

  def testServiceUnavailableOnceNotRetryable
    # mock will break pipe first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Amazon::WebServices::Util::ValidationException.new(nil, 'AWS.ServiceUnavailable')
      end
      nil
    end

    # invoking a non-retryable call will throw an exception
    begin
      @mturk.grantBonus
      fail "Should have thrown an exception"
    rescue Amazon::WebServices::Util::ValidationException
      # expect this exception
    end
    assert_equal :GrantBonus, @mock.next.name
    assert_nil @mock.next
  end

  def testServiceUnavailableOnceRetryableUniqueRequestToken
    # mock will reset connection first time, return success on second call
    should_fail = true
    @mock.listen do |call|
      if should_fail
        should_fail = false
        raise Amazon::WebServices::Util::ValidationException.new(nil, 'AWS.ServiceUnavailable')
      end
      nil
    end

    # invoke call with an idempotency once, should auto-retry and return success
    @mturk.grantBonus :UniqueRequestToken => 'UniqueTokenValue'
    assert_equal 2, @mock.call_buffer.size, "Should have retried once"
    @mock.each {|call| assert_equal :GrantBonus, call.name, "Should have been a GrantBonus call" }
  end

  def testServiceUnavailableAlways
    #mock will always break pipe
    @mock.listen do |call|
        raise Amazon::WebServices::Util::ValidationException.new(nil, 'AWS.ServiceUnavailable')
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue Amazon::WebServices::Util::ValidationException
      # expect this exception
    end

    RETRYABLE_ATTEMPT_COUNT.times do
      assert_equal :SearchHITs, @mock.next.name
    end
    assert_nil @mock.next
  end

  def testGenericValidationException
    @mock.listen do |call|
      raise Amazon::WebServices::Util::ValidationException.new(nil, 'Blah blah')
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue Amazon::WebServices::Util::ValidationException
      # expect this exception
    end
    assert_equal :SearchHITs, @mock.next.name
    assert_nil @mock.next
  end

  def testRuntimeError
    @mock.listen do |call|
      raise "Blah"
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue RuntimeError => e
      assert_equal "Blah", e.to_s
    end
  end

  def testRuntimeErrorThrottled
     @mock.listen do |call|
      raise "Throttled"
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue RuntimeError => e
      assert_equal "Throttled", e.to_s
    end
  end

  if Amazon::WebServices::Util::SOAPTransport.canSOAP?
  def testSOAPFaultError
    arg = (Struct.new :faultcode, :faultstring, :faultactor, :detail).new 
    arg.faultcode = (Struct.new :data).new 'aws:blarg'
    arg.faultstring = (Struct.new :data).new 'blarg blarg blarg'
    s = SOAP::FaultError.new( arg )
    
    @mock.listen do |call|
      raise s
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue SOAP::FaultError => e
      assert_equal s, e
    end
  end

  def testSOAPFaultErrorThrottled
    arg = (Struct.new :faultcode, :faultstring, :faultactor, :detail).new 
    arg.faultcode = (Struct.new :data).new 'aws:Server.ServiceUnavailable'
    arg.faultstring = (Struct.new :data).new 'Hey, give us a break!'
    s = SOAP::FaultError.new( arg )
    
    @mock.listen do |call|
      raise s
    end

    begin
      @mturk.searchHITs
      fail "Should have thrown an exception"
    rescue SOAP::FaultError => e
      assert_equal s, e
    end
  end
  end # canSOAP?

end
