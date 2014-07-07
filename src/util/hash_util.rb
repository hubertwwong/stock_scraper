require 'rubygems'

class HashUtil
  
  # adds a new hash value to an array of hashes.
  # assumes the other struct is an array and inner struct is a hash.
  def self.add_constant_to_array_hash(cur_array_hash, new_hash)
    final_array = Array.new
    
    # basic check
    if cur_array_hash == nil || new_hash ==  nil
      return nil
    end
    
    # cycle thru each array item
    cur_array_hash.each do |cur_hash|
      # modify hash
      final_hash = self.add_constant(cur_hash, new_hash)
      
      # save hash result
      final_array << final_hash
    end
    
    return final_array
  end
  
  # loads a constant hash value into a current value.
  # could be used for stuff like loading specific keys
  # for a db insert.
  def self.add_constant(cur_hash, new_hash)
    final_hash = cur_hash
    
    # basic check
    if cur_hash == nil || new_hash ==  nil
      return nil
    end
    
    # load new hash.
    new_hash.each do |key, value|
      final_hash[key] = value
    end
    
    return final_hash
  end
  
  # test
  ############################################################################
  
  def self.hello
    true
  end
    
end