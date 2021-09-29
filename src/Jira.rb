require 'jira-ruby'
require 'colorize'

require './src/System'

class Jira

  attr_reader :options, :client

  JIRAYA_FILE_CONF = System.new().programFolder + 'jiraya.conf'

  def initialize(username:'', password:'', site:'')
    if username.empty? || password.empty? || site.empty?
      raise 'Invalid credentials.'
    end

    @options = {
      :username     => username,
      :password     => password,
      :site         => site,
      :context_path => '',
      :auth_type    => :basic
    }

    @client = JIRA::Client.new(options)
  end

  def validate()
    begin  
      client.Project.all
    rescue 
      puts 'Invalid credentials.'.red
      File.open(JIRAYA_FILE_CONF, 'w') {|file| file.truncate(0) }
      exit
    end 
  end

  def findIssueBy(name:)
    begin
      return client.Issue.find(name)
    rescue
      puts ('Issue ' + name + ' not found.').red
      return nil
    end
  end

  def saveWorkLogFrom(item:, issue:)
    begin
      workLog = issue.worklogs.build
      workLog.save!("timeSpent" => item.timeSpent, "comment" => item.comment, "started" => item.startTime)
      puts "[OK] #{item.issueName} - #{issue.summary}".green
    rescue => exception
      puts "[ERROR] #{item.issueName} - #{issue.summary} \n #{exception}".red
    end
  end
end