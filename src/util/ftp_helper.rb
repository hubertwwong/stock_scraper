require 'net/ftp'
require 'pathname'

require_relative 'file_wrapper_util'

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
    # normalize dir path.
    pn = Pathname.new(src_dir)
    final_src_dir = pn.split[0].to_s + "/" + pn.split[1].to_s
    pn = Pathname.new(dest_dir)
    final_dest_dir = pn.split[0].to_s + "/" + pn.split[1].to_s
    
    # create the dest directory if it doest not exist.
    FileWrapperUtil.mkdir_p(final_dest_dir)
    
    # change dir...
    @ftp.chdir(src_dir)
    
    # grab a list of files.
    # and download each file.
    @ftp.nlst.each do |f|
      puts ">" + f + "<"
      ftp_file = final_src_dir + "/" + f
      
      puts "fetching " + ftp_file
      self.download_file(ftp_file, final_dest_dir)
    end
  end
  
  # assumes binary file download...
  # should work on test files.
  # also...
  # src_path is the full download path on the ftp site
  # dest_dir is the destination on the hard drive where you want to save.
  # - note that ftp lib needs the file name
  # - so this little helper will grab that file name from the src_path.
  # - and appending it the download file.
  def download_file(src_path, dest_dir)
    pn = Pathname.new(src_path)
    filename = pn.split[1].to_s
    
    #puts ">>>> final_dest_path"
    
    # normalize dest path name.
    # so you don't have to worry as much.
    pn = Pathname.new(dest_dir)
    final_dest_dir = pn.split[0].to_s + "/" + pn.split[1].to_s
    #puts ">>>> " + final_dest_dir.to_s
    final_dest_path = final_dest_dir + "/" + filename
    #puts final_dest_path
    #puts ">>>> final_dest_path"
    
    # create the dest directory if it doest not exist.
    FileWrapperUtil.mkdir_p(final_dest_dir)
    
    # grab the file.
    @ftp.getbinaryfile(src_path, final_dest_path)
  end
  
  def disconnect
    @ftp.close
  end
  
end