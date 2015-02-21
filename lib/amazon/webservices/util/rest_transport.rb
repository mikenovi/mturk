# Copyright:: Copyright (c) 2007 Amazon Technologies, Inc.
# License::   Apache License, Version 2.0

require 'cgi'
require 'net/https'
require 'rubygems'
require 'nokogiri'
require 'amazon/webservices/util/xml_simplifier'

module Amazon
module WebServices
module Util

class RESTTransport

  REQUIRED_PARAMETERS = [:Endpoint]

  def self.canPost?
    Net::HTTP.respond_to? :post_form
  end

  def initialize( args )
    missing_parameters = REQUIRED_PARAMETERS - args.keys
    raise "Missing paramters: #{missing_parameters.join(',')}" unless missing_parameters.empty?
    @uri = URI.parse( args[:Endpoint] )
    @httpMethod = resolveHTTPMethod( args[:RestStyle] )
    @version = args[:Version]
    @ssl = (@uri.scheme == 'https') || (@uri.port == 443) || args[:UseSSL]
    @skip_ssl_verify = args[:SkipSSLCheck]

    agent = ::MTurk::agent( args[:SoftwareName] )
    @headers = {
      'User-Agent' => agent,
      'X-Amazon-Software' => agent,
      'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8',
    }
  end

  def resolveHTTPMethod( method )
    case method.to_s.upcase
    when "GET"
      return :GET
    when "POST"
      raise "Your version of Ruby does not support HTTP Post" unless RESTTransport.canPost?
      return :POST
    else
      return ( RESTTransport.canPost? ? :POST : :GET )
    end
  end

  def method_missing( method, *args )
    params = { :Operation => method, :Version => @version }
    params.merge!( args[0].delete( :Request )[0] )
    params.merge!( args[0] )

    http = Net::HTTP.new( @uri.host, @uri.port )
    if @ssl
      http.use_ssl = true
      if @skip_ssl_verify
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end

    req = nil
    if @httpMethod == :GET
      req = Net::HTTP::Get.new( @uri.request_uri + toQueryString(params), @headers )
    else
      req = Net::HTTP::Post.new( @uri.request_uri, @headers )
      req.form_data = toPostParams( params )
      req['Content-Type'] = @headers['Content-Type'] # necessary because req.form_data resets Content-Type header
    end

    res = http.start { |conn|
      conn.request(req)
    }.body

    xml = Nokogiri::XML( res )
    XMLSimplifier.simplify xml
  end

  private

  def toQueryString(params)
    queryString = ""
    each_http_param(params) { |key,value|
      queryString << ( '&' + key + '=' + CGI.escape(value) )
    }
    return queryString
  end

  def toPostParams(params)
    postParams = {}
    each_http_param(params) { |key,value|
      postParams[key] = value }
    return postParams
  end

  def each_http_param(params,&block)
    params.each {|k,v| each_http_param_helper( k, v, false, &block ) unless v.nil? }
  end

  def each_http_param_helper(key,value,num=false,&block)
    key = key.to_s
    case value.class.to_s
    when 'Array'
      value.each_with_index { |v,i| each_http_param_helper( "#{key}.#{i+1}", v, true, &block ) unless v.nil? }
    when 'Hash'
      value.each { |k,v| each_http_param_helper( "#{key}#{num ? '.' : '.1.'}#{k}", v, false, &block ) unless v.nil? }
    else
      yield key, value.to_s
    end
  end

end # RESTTransport

end # Amazon::WebServices::Util
end # Amazon::WebServices
end # Amazon
