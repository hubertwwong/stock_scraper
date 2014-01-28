require 'net/ftp'

# provides a few convience methods...
# the big thing being a method to queue up a ton of files
# to download.
class FTPHelper
  
  attr_accessor :url, :user, :password, :ftp
  
  def initialize(params = {})
    @url = params[:url]
    @ftp = Net::FTP.new(@url)
    @ftp.passive = true
    # assuming passive mode.
  end
  
  # return the ftp object.
  # in case you need to do somethign with it.
  def ftp
    return @ftp
  end
  
  def connect
    # checks if the user variable is defined.
    if @user == nil
      @ftp.login
    else
      @ftp.login @user, @password
    end
  end
  
  # the main method.
  #
  # lists_of
  # an array of strings. the strings can either be a directory or files.
  # basically what you are dowloading...
  # 
  # dest_dir
  # local directory that files will be downloaded to.
  def download_all(lists_of, dest_dir)
    
  end
  
  # downloads all files in a single directory.
  def download_dir(src_dir, dest_dir)
    
  end
  
  # assumes binary file download...
  # should work on test files.
  # also...
  # src_file is the full download path on the ftp site
  # dest_dir is the destination on the hard drive where you want to save.
  def download_file(src_file, dest_dir)
    @ftp.getbinaryfile(src_file, dest_dir)
  end
  
  def disconnect
    @ftp.close
  end
  
end