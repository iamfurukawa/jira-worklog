#require 'date'

class RowBase
  attr_reader :issueName, :timeSpent, :startTime, :comment

  def initialize(issueName:, timeSpent:, startTime:, comment:)
    if issueName == nil || issueName.empty?
      raise "Issue name is empty!"
    end
    
    if timeSpent == nil || !timeSpent.match(/\d*[wdhm]{0,1}\d*[wdhm]{0,1}\d*[wdhm]{0,1}\d*[wdhm]{0,1}/)
      raise "Time Spent not match with the pattern!"
    end

    if startTime != nil && !startTime.match(/\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\d-\d\d\d\d/)
      raise "Invalid start time!"
    end

    @issueName = issueName
    @timeSpent = timeSpent
    @startTime = startTime # || Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L-0300")
    @comment = comment || ""
  end

  def to_s
    "Issue: #{@issueName}" + " Time Spent: #{@timeSpent}" + " Start Time: #{@startTime}" + " Comment: #{@comment}"
   end
end