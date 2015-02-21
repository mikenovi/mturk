#!/usr/bin/env ruby

# Copyright:: Copyright (c) 2007 Amazon Technologies, Inc.
# License::   Apache License, Version 2.0

begin ; require 'rubygems' ; rescue LoadError ; end

# The Review Policy sample application will create a HIT which utilizes review policies

require 'mturk'
@mturk = Amazon::WebServices::MechanicalTurkRequester.new

# Check to see if your account has sufficient funds
def hasEnoughFunds?
  available = @mturk.availableFunds
  puts "Got account balance: %.2f" % available
  return available > 0.055
end

def getHITUrl( hitTypeId )
  if @mturk.host =~ /sandbox/
    "http://workersandbox.mturk.com/mturk/preview?groupId=#{hitTypeId}" # Sandbox Url
  else
    "http://mturk.com/mturk/preview?groupId=#{hitTypeId}" # Production Url
  end
end

def questionXml
  rootDir = File.dirname $0
  questionFile = rootDir + "/review_policy.question"
  question = File.read( questionFile )
end

# Helper function to convert policy parameters
def kv_map(hash)
  hash.collect do |k,v|
    case v
    when Hash
      { :Key => k, :MapEntry => kv_map(v) }
    else
      { :Key => k, :Value => v }
    end
  end
end

def createMyHit
  scoreKnownAnswersPolicy = {
    :PolicyName => 'ScoreMyKnownAnswers/2011-09-01',
    :Parameter => kv_map({
      'ApproveIfKnownAnswerScoreIsAtLeast' => 100,
      'ApproveReason' => 'You can count',
      'RejectIfKnownAnswerScoreIsLessThan' => 50,
      'RejectReason' => 'You flunked math',
      'ExtendIfKnownAnswerScoreIsLessThan' => 50,
      'AnswerKey' => { 'q1' => 2, 'q2' => 4 }
    }),
  }

  pluralityHitReviewPolicy = {
    :PolicyName => 'SimplePlurality/2011-09-01',
    :Parameter => kv_map({
      'QuestionIds' => ['q3'],
      'QuestionAgreementThreshold' => 49,
      'ExtendIfHITAgreementScoreIsLessThan' => 100,
      'ExtendAssignments' => 1,
      'ExtendMaximumAssignments' => 10,
      'ApproveIfWorkerAgreementScoreIsAtLeast' => 100,
      'RejectIfWorkerAgreementScoreIsLessThan' => 100,
    }),
  }

  hit_properties = {
    :Title       => 'Answer some questions',
    :Description => 'This is a HIT created by the Mechanical Turk SDK.  Please answer the provided questions.',
    :Keywords    => '',
    :Reward => {
      :CurrencyCode => 'USD',
      :Amount       => 0.00
    },
    :RequesterAnnotation         => 'Test Hit',
    :AssignmentDurationInSeconds => 60 * 60,
    :AutoApprovalDelayInSeconds  => 60 * 60 * 10,
    :MaxAssignments              => 3, # review policy requires multiple assignments per hit
    :LifetimeInSeconds           => 60 * 60,
    :Question                    => questionXml,
    :AssignmentReviewPolicy      => scoreKnownAnswersPolicy,
    :HITReviewPolicy             => pluralityHitReviewPolicy,
  }
  hit = @mturk.createHIT( hit_properties )

  puts "Created HIT: #{hit[:HITId]}"
  puts "Url: #{getHITUrl( hit[:HITTypeId] )}"
end

def displayPolicy(name,report)
  puts "Results for policy #{name}:"
  [report[:ReviewResult]].flatten.each do |result|
    q = result[:Key]
    q += " for #{result[:QuestionId]}" unless result[:QuestionId].to_s == ""
    puts "- %s %s: %s is %s" % [result[:SubjectType],result[:SubjectId],q,result[:Value]]
  end unless report[:ReviewResult].nil?
  puts "Actions for policy #{name}:"
  [report[:ReviewAction]].flatten.each do |action|
    puts " - Action %s on %s %s: %s" % [action[:ActionName],action[:ObjectType],action[:ObjectId],action[:ActionStatus]]
    puts "  Result: #{action[:Result]}"
  end unless report[:ReviewAction].nil?
end

def getMyHitResults(hitId)
  puts "Getting review policy results for HIT #{hitId}"
  rez = @mturk.getReviewResultsForHIT( :HITId => hitId,
                                       :PolicyLevel => ['Assignment','HIT'],
                                       :RetrieveActions => true,
                                       :RetrieveResults => true,
                                       :PageNumber => 1,
                                       :PageSize => 1000 )
  displayPolicy(rez[:HITReviewPolicy][:PolicyName],rez[:HITReviewReport]) unless rez[:HITReviewPolicy].nil?
  displayPolicy(rez[:AssignmentReviewPolicy][:PolicyName],rez[:AssignmentReviewReport]) unless rez[:AssignmentReviewPolicy].nil?
end

def usage
  puts <<EOF
Usage:
  ReviewPolicy.rb
    This will load a hit configured with sample review policies
  ReviewPolicy.rb [HitId]
    This will retrieve review policy information about the identified HIT
EOF
end


case ARGV.size
when 0
  createMyHit if hasEnoughFunds?
when 1
  getMyHitResults(ARGV[0])
else
  usage
end
