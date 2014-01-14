# a few simple hepler utils for string manipulations.
class StrUtil
  
  # convert a string to array
  # splits off non alpha numeric
  # 
  def self.str_to_array(sym_param)
    if sym_param != nil
      # split off non word characters
      return sym_param.split(/\W/)
    else
      return nil
    end  
  end
  
end