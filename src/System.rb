class System

  def initialize()
    FileUtils.mkdir_p programFolder
  end

  def programFolder
    return 'jiraya/'
  end
end