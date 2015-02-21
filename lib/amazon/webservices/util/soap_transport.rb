# Copyright:: Copyright (c) 2007 Amazon Technologies, Inc.
# License::   Apache License, Version 2.0

module Amazon
module WebServices
module Util

class SOAPTransport

  def initialize(args)
    raise 'SOAP no longer supported'
  end

  def self.canSOAP? ; false ; end

end # SOAPTransport

end # Amazon::WebServices::Util
end # Amazon::WebServices
end # Amazon
