require 'csv'
require 'date'
require 'fileutils'

require './src/RowBase'
require './src/System'

class FileManager

  JIRAYA_FILE_CSV = System.new().programFolder + 'journal.csv'

  def initialize()
    if !File.file?(JIRAYA_FILE_CSV)
      createDefaultFile
    end
  end

  def read()
    data = []
    headers = CSV.read(JIRAYA_FILE_CSV, headers: true, encoding: "utf-8").headers

    CSV.foreach(JIRAYA_FILE_CSV, headers: true, col_sep: ';', row_sep: "\r\n", encoding: "utf-8") do |row|
      data << RowBase.new(issueName: row[0], timeSpent: row[1], startTime: row[2], comment: row[3])
    end

    return data, headers
  end

  def createDefaultFile()
    puts 'Generate default file.'.yellow
    File.write(JIRAYA_FILE_CSV, "Item (e.g. ASDF-1234);Tempo gasto (e.g. 1w 2d 3h 4m);Data inicial (e.g. 2021-09-23T12:53:43.030-0300);Comentario (e.g. Tarefa maneira!);", mode: "w")
    exit
  end

  def rename()
    FileUtils.mkdir_p System.new().programFolder + 'history'
    now = Time.now.getlocal('-03:00').strftime("%d-%m-%Y %Hh%Mm")
    File.chmod(0777, JIRAYA_FILE_CSV) rescue nil
    File.rename(JIRAYA_FILE_CSV, System.new().programFolder + 'history/journal ' + now + File.extname(JIRAYA_FILE_CSV))
    puts 'Renaming file and moving to history folder, thanks for use!'.green
    createDefaultFile
  end
end