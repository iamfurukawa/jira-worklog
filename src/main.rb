require 'rubygems'
require 'io/console'
require 'colorize'
require 'parallel'

require './src/FileManager'
require './src/Credentials'
require './src/Jira'

def getInfos()
  puts "Welcome to Jiraya!"
  puts "What's your username? (E.g. example@example.com.br)".yellow
  username = gets

  puts "What's your jira url? (E.g. https://somename.atlassian.net/)".yellow
  site = gets

  puts "Now access https://id.atlassian.com/manage-profile/security/api-tokens and generate a new token before continue".red
  puts "What's your generated key? (E.g. 7oFV91HU9HFYI1ossryhA5A8)".yellow
  puts "For your security, the key will not appear in the screen!".yellow
  password = STDIN.noecho(&:gets)

  Jira.new(username:username.strip , password:password.strip , site:site.strip).validate

  Credentials.new().create(username:username.strip , password:password.strip , site:site.strip)

  puts "Ok now restart the program pls!".green
  exit
end

#Retrieving credentials from file
credentialsData = Credentials.new().retrieve

#Validating data, if not exists, request credentials and exit the program
if credentialsData == nil
  getInfos
end

#Validate data when read from file
jiraClient = Jira.new(username:credentialsData[0].strip , password:credentialsData[1].strip , site:credentialsData[2].strip)
jiraClient.validate

#Open CSV and validating
fileManager = FileManager.new

#Reading CSV
rows, headers = fileManager.read

#Validating if CSV is empty, then create default file and exiting.
if rows.size == 0 && headers == nil
  fileManager.createDefaultFile
elsif rows.size == 0 && headers != nil #Not will execute the batch
  puts 'No rows to be executed. Exiting.'.green
  exit
end

#each row
Parallel.each(rows, in_threads: 10) do |item|
  #search by issue
  issue = jiraClient.findIssueBy(name: item.issueName)

  #if nil, issue not exists, so cancel operation
  if issue == nil
    next
  end

  #else save worklog
  jiraClient.saveWorkLogFrom(item: item, issue: issue)  
end

#Rename file and re-create the default
fileManager.rename
