# -*- encoding: utf-8 -*-
# stub: mturk 1.9.0.20150221102815 ruby lib

Gem::Specification.new do |s|
  s.name = "mturk"
  s.version = "1.9.0.20150221102815"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Novi"]
  s.date = "2015-02-21"
  s.description = "Mechanical Turk Ruby Libraries (mturk) is a set of libraries and tools\ndesigned to make it easier for you to build solutions leveraging Amazon\nMechanical Turk.  The goals of the libraries are:\n\n* To abstract you from the \"muck\" of using web services\n* To simplify using the Mechanical Turk APIs\n* To allow you to focus more on solving the business problem\n  and less on managing technical details"
  s.email = "me@michaelnovi.com"
  s.executables = ["mturk"]
  s.extra_rdoc_files = ["History.md", "LICENSE.txt", "Manifest.txt", "NOTICE.txt", "README.md"]
  s.files = [".gemtest", "History.md", "LICENSE.txt", "Manifest.txt", "NOTICE.txt", "README.md", "Rakefile", "bin/mturk", "lib/amazon/util.rb", "lib/amazon/util/binder.rb", "lib/amazon/util/data_reader.rb", "lib/amazon/util/filter_chain.rb", "lib/amazon/util/hash_nesting.rb", "lib/amazon/util/lazy_results.rb", "lib/amazon/util/logging.rb", "lib/amazon/util/paginated_iterator.rb", "lib/amazon/util/proactive_results.rb", "lib/amazon/util/threadpool.rb", "lib/amazon/util/user_data_store.rb", "lib/amazon/webservices/mechanical_turk.rb", "lib/amazon/webservices/mechanical_turk_requester.rb", "lib/amazon/webservices/mturk/mechanical_turk_error_handler.rb", "lib/amazon/webservices/mturk/question_generator.rb", "lib/amazon/webservices/util/amazon_authentication_relay.rb", "lib/amazon/webservices/util/command_line.rb", "lib/amazon/webservices/util/convenience_wrapper.rb", "lib/amazon/webservices/util/filter_proxy.rb", "lib/amazon/webservices/util/mock_transport.rb", "lib/amazon/webservices/util/request_signer.rb", "lib/amazon/webservices/util/rest_transport.rb", "lib/amazon/webservices/util/soap_simplifier.rb", "lib/amazon/webservices/util/soap_transport.rb", "lib/amazon/webservices/util/soap_transport_header_handler.rb", "lib/amazon/webservices/util/unknown_result_exception.rb", "lib/amazon/webservices/util/validation_exception.rb", "lib/amazon/webservices/util/xml_simplifier.rb", "lib/mturk.rb", "lib/mturk/version.rb", "run_rcov.sh", "samples/best_image/BestImage.rb", "samples/best_image/best_image.properties", "samples/best_image/best_image.question", "samples/blank_slate/BlankSlate.rb", "samples/blank_slate/BlankSlate_multithreaded.rb", "samples/helloworld/MTurkHelloWorld.rb", "samples/helloworld/mturk.yml", "samples/review_policy/ReviewPolicy.rb", "samples/review_policy/review_policy.question", "samples/reviewer/Reviewer.rb", "samples/reviewer/mturk.yml", "samples/simple_survey/SimpleSurvey.rb", "samples/simple_survey/simple_survey.question", "samples/site_category/SiteCategory.rb", "samples/site_category/externalpage.htm", "samples/site_category/site_category.input", "samples/site_category/site_category.properties", "samples/site_category/site_category.question", "test/mturk/test_changehittypeofhit.rb", "test/mturk/test_error_handler.rb", "test/mturk/test_mechanical_turk_requester.rb", "test/mturk/test_mock_mechanical_turk_requester.rb", "test/test_mturk.rb", "test/unit/test_binder.rb", "test/unit/test_data_reader.rb", "test/unit/test_exceptions.rb", "test/unit/test_hash_nesting.rb", "test/unit/test_lazy_results.rb", "test/unit/test_mock_transport.rb", "test/unit/test_paginated_iterator.rb", "test/unit/test_proactive_results.rb", "test/unit/test_question_generator.rb", "test/unit/test_threadpool.rb", "test/unit/test_user_data_store.rb"]
  s.homepage = "https://requester.mturk.com/"
  s.licenses = ["APLv2"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby libraries for working with Mechanical Turk"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.2.7"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.13"])
    else
      s.add_dependency(%q<highline>, [">= 1.2.7"])
      s.add_dependency(%q<nokogiri>, [">= 1.4"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.13"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.2.7"])
    s.add_dependency(%q<nokogiri>, [">= 1.4"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.13"])
  end
end
