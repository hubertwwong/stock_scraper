require 'yaml'

# some simple yaml functions to help out.
class YamlUtil
  
  def self.read(filename)
    #puts "> loading > " + filename
    YAML.load_file(filename)
  end
  
  # note that if you want to update a hash
  # use the .store method.
  # so cur_hash.store('foo', 100)
  # and then call this function to save it
  def self.write(filename, cur_hash)
    File.open(filename, "w") do |f|
      f.write(cur_hash.to_yaml)
    end
  end
  
end