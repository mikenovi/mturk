== 1.9.0 / 2015-02-21
=== 1 major enhancement
* Updated the rails config function to use new Rails paths/environments
* Provides ERB parsing of YAML for secure config storage

== 1.8.1 / 2015-02-16

=== 1 minor update
* Fix namespacing in command line tool

== 1.8.0 / 2015-02-16

=== 2 major enhancement
* New name!
* Update MechanicalTurk WSDL version to 2014-08-15

== 1 minor enhancement
* Update sample ExternalQuestion URLs to HTTPS

== 1.7.1 / 2014-10-20

=== 1 minor update
* Correctly generate version.rb

== 1.7.0 / 2014-10-17

=== 1 major enhancement
* Update MechanicalTurk WSDL version to 2013-11-15 (Qualification Requirement Set Comparators: In/NotIn/DoesNotExist)

=== 4 minor updates
* Improve retriable error detection
* Add constants for new QualificationTypeIds
* Updates for Hoe and Ruby deprecations
* Rename markdown files w/ .md extension

== 1.6.0 / 2012-08-23

=== 1 major enhancement
* Remove support for SOAP transport (will fallback to REST if SOAP is requested)

== 1.5.0 / 2012-03-28

=== 1 major enhancement
* Update MechanicalTurk WSDL version to 2012-03-25 (getBlockedWorkers, getAssignment, approveRejectedAssignment)

=== 1 minor enhancements
* Address unused variable warnings

== 1.4.0 / 2011-12-01

=== 2 major enhancements
* Update MechanicalTurk WSDL version to 2011-10-01 (getReviewResultsForHIT, disposeQualificationType, getRequesterWorkerStatistic)
* Add Review Policy Sample Application

=== 7 minor enhancements
* Switch from REXML to Nokogiri
* Add Rails configuration option
* Make MechanicalTurkErrorHandler more robust
* ErrorHandler will retry on AWS.ServiceUnavailable
* Fix XmlSimplifier to support negative numbers
* Improve robustness of MechanicalTurkRequester#createHITs
* Confirm before saving authentication information

== 1.3.1 / 2011-05-05

=== 2 major enhancements
* Ruby 1.9 compatibility
* Add support for :UseSSL option (Default enabled for MechanicalTurk)

=== 1 minor enhacement
* Upgrade to latest Hoe spec

== 1.2.0 / 2007-10-11

=== 3 major enhancements
* Threading optimizations for bulk convenience operations:
  createHITs, updateHITs, and getHITResults
* Paginated extension xxxAllProactive -- retrieves results proactively
  via a threadpool
* Paginated extension xxxIterator -- hands back an iterator instead
  of buffered results, for streaming large result sets

=== 2 minor enhancements
* Enhanced test coverage
* Rest transport now default (previously SOAP)

== 1.1.1 / 2007-08-28

=== 0 major enhancements

=== 3 minor enhancements
* createHITs now supports MaxAssignments correctly
* Generate .zip file
* Documentation correction

== 1.1.0 / 2007-08-06

=== 2 major enhancements
* Updated for Mechanical Turk's 2007-06-21 WSDL (updateHIT, blockWorker)
* Added enhanced error handling system with retry logic

== 3 minor enhancements
* Samples try to require rubygems
* BlankSlate now disposes hits with pending assignments (approves them)
* BlankSlate now aborts when it gets an Interrupt (CTRL-C)

== 1.0.0 / 2007-07-13

=== 1 major enhancement
* Birthday!
