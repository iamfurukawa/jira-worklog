require 'aes'
require 'colorize'

require './src/System'

class Credentials
  attr_reader :username, :password, :site

  JIRAYA_FILE_CONF = System.new().programFolder + 'jiraya.conf'
  KEY = 'ce07203c1b2daf678355c32c7e1e1d0dd321116b1068ab002e2ed3262b6fed6bc262332f7504'

  def initialize()
    credentialsFile = nil
    if !File.file?(JIRAYA_FILE_CONF)
      puts "Creating conf file".yellow
      credentialsFile = File.open(JIRAYA_FILE_CONF, "w")
      credentialsFile.close
    end
  end

  def retrieve()
    puts "Retrieving confs".yellow
    credentialsFile = File.open(JIRAYA_FILE_CONF, "r")
    lines = credentialsFile.readlines.map(&:chomp)
    credentialsFile.close

    if lines.size != 3
      puts "No configurations found".red
      return nil
    end

    puts "Configurations found".yellow
    begin
      return AES.decrypt(lines[0], KEY).tr("\n",""),
        AES.decrypt(lines[1], KEY).tr("\n",""), 
        AES.decrypt(lines[2], KEY).tr("\n","")
    rescue
      puts 'Configs are corrupted, clean config file for security.'.red
      File.open(JIRAYA_FILE_CONF, 'w') {|file| file.truncate(0) }
      exit
    end
  end

  def create(username:, password:, site:)
    File.write(JIRAYA_FILE_CONF, [
        AES.encrypt(username, KEY).tr("\n",""), 
        AES.encrypt(password, KEY).tr("\n",""), 
        AES.encrypt(site, KEY).tr("\n","")
      ].join("\n"), mode: "w")
  end

end