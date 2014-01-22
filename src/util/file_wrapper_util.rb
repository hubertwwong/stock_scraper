require 'fileutils'

# some simple wrapper of files utils.
# mostly convienence things.
# like adding a wrapper directoryy.
# added the word wrapper to the class so its
# not confused with the inbuilt one.
class FileWrapperUtil
  
  # a wrapper to the move command.
  # basically creates the necessary directories.
  def self.mv(src, dest)
    FileUtils.mkdir_p(File.dirname(dest))
    FileUtils.mv(src, dest)
    return true
  end
  
  # a wrapper to the copy command...
  # creates the necessary directories automatically.
  def self.cp(src, dest)
    # my hunch is that you don't need the file.dirname.
    # unless you are passing something other than a directory.
    #FileUtils.mkdir_p(File.dirname(dest))
    FileUtils.mkdir_p(dest)
    FileUtils.cp(src, dest)
    return true
  end
  
  # probalby want a way to pass thru the file util handle.
  # so you can access it in one place.
  def self.rm_rf(src)
    FileUtils.rm_rf(src)
    return true
  end
  
  def self.mkdir_p(dest)
    #puts "dest" + dest
    FileUtils.mkdir_p(dest)
    return true
  end
  
end