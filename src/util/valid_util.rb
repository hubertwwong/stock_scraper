require 'rubygems'
require 'date'

# adding some basic validations to check.
# stuff like if a string is a valid date or valid number.
class ValidUtil
  
  # checks if the number is an int.
  def self.valid_int?(some_int)
    if some_int == nil
      return false
    else
      num_as_str = some_int.to_s
      if /^[\d]+$/.match(num_as_str)
        return true
      else
        return false
      end
    end
  end
  
  # checks if the value is some int.
  # using a regex.
  # using the begin to check for nil...
  # checking for dollar values.
  # - will be true on ints or floats with 1 or 2 decimals.
  #
  # does not check if its a string or int or float.
  # does a to_s conversion first.
  # so it will work with numbers.
  def self.valid_money?(some_num)
    if some_num == nil
      return false
    else
      num_as_str = some_num.to_s
      if /^[\d]+(\.[\d]{1,2}){0,1}$/.match(num_as_str)
        return true
      else
        return false
      end
    end
  end
  
  # checks if a date is valid.
  # one thing it wont handle is stuff like 201300112233
  # pure numbers. i think the parse method is taking this to mean time.
  def self.valid_date?(some_date)
    begin
       Date.parse(some_date)
       return true
    rescue
       return false
    end
  end
  
  # not tested...
  def self.valid_string?(some_str)
    if some_str == nil
      return false
    else
      return some_str.is_a?(String)
    end
  end
  
  # a conveinence method that checks if the values have the correct types.
  # 
  # so lets say you have a hash.
  # {:foo => 1, :bar => "potato"}
  # you can set the param_hash to check for types.
  # {:foo => "i", :bar => "s"}
  # will return true.
  def self.valid_hash_type?(some_hash, param_hash)
    if some_hash == nil || param_hash == nil
      return false
    end
    
    param_hash.keys.each do |k|
      cur_val = some_hash[k]
      cur_type = param_hash[k]
      
      # if either value is null return false.
      # short circut.
      if cur_val == nil || cur_type == nil
        return false
      else
        if cur_type == "i"
          if ValidUtil.valid_int? cur_val
            true
          else
            return false
          end    
        elsif cur_type == "m"
          if ValidUtil.valid_money? cur_val
            true
          else
            return false
          end
        elsif cur_type == "s"
          if ValidUtil.valid_string? cur_val
            true
          else
            return false
          end
        elsif cur_type == "d"
          if ValidUtil.valid_date? cur_val
            true
          else
            return false
          end
        else
          return false
        end
      end
    end
    
    return true
  end
  
  # checking if this works.
  def self.hello
    true
  end
  
end