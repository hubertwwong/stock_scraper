class StateUtil
  
  # converts an abbv to a state. 
  def self.abbv_to_state(abbv)
    state_name = Hash.new
    
    state_name['AL'] = 'ALABAMA' 
    state_name['AK'] = 'ALASKA'
    state_name['AS'] = 'AMERICAN SAMOA'
    state_name['AZ'] = 'ARIZONA'
    state_name['AR'] = 'ARKANSAS'
    state_name['CA'] = 'CALIFORNIA'
    state_name['CO'] = 'COLORADO'
    state_name['CT'] = 'CONNECTICUT'
    state_name['DE'] = 'DELAWARE' 
    state_name['DC'] = 'DISTRICT OF COLUMBIA'
    state_name['FM'] = 'FEDERATED STATES OF MICRONESIA'
    state_name['FL'] = 'FLORIDA'
    state_name['GA'] = 'GEORGIA'
    state_name['GU'] = 'GUAM GU' 
    state_name['HI'] = 'HAWAII' 
    state_name['ID'] = 'IDAHO' 
    state_name['IL'] = 'ILLINOIS' 
    state_name['IN'] = 'INDIANA'
    state_name['IA'] = 'IOWA'
    state_name['KS'] = 'KANSAS'
    state_name['KY'] = 'KENTUCKY'
    state_name['LA'] = 'LOUISIANA'
    state_name['ME'] = 'MAINE'
    state_name['MH'] = 'MARSHALL ISLANDS'
    state_name['MD'] = 'MARYLAND'
    state_name['MA'] = 'MASSACHUSETTS'
    state_name['MI'] = 'MICHIGAN'
    state_name['MN'] = 'MINNESOTA'
    state_name['MS'] = 'MISSISSIPPI'
    state_name['MO'] = 'MISSOURI'
    state_name['MT'] = 'MONTANA'
    state_name['NE'] = 'NEBRASKA'
    state_name['NV'] = 'NEVADA'
    state_name['NH'] = 'NEW HAMPSHIRE'
    state_name['NJ'] = 'NEW JERSEY'
    state_name['NM'] = 'NEW MEXICO'
    state_name['NY'] = 'NEW YORK'
    state_name['NC'] = 'NORTH CAROLINA'
    state_name['ND'] = 'NORTH DAKOTA'
    state_name['MP'] = 'NORTHERN MARIANA ISLANDS'
    state_name['OH'] = 'OHIO'
    state_name['OK'] = 'OKLAHOMA'
    state_name['OR'] = 'OREGON'
    state_name['PW'] = 'PALAU'
    state_name['PA'] = 'PENNSYLVANIA'
    state_name['PR'] = 'PUERTO RICO'
    state_name['RI'] = 'RHODE ISLAND'
    state_name['SC'] = 'SOUTH CAROLINA'
    state_name['SD'] = 'SOUTH DAKOTA'
    state_name['TN'] = 'TENNESSEE'
    state_name['TX'] = 'TEXAS'
    state_name['UT'] = 'UTAH'
    state_name['VT'] = 'VERMONT'
    state_name['VI'] = 'VIRGIN ISLANDS'
    state_name['VA'] = 'VIRGINIA'
    state_name['WA'] = 'WASHINGTON'
    state_name['WV'] = 'WEST VIRGINIA'
    state_name['WI'] = 'WISCONSIN'
    state_name['WY'] = 'WYOMING'
    
    # military states are being used.
    # there are more...
    # with the same initals.
    # https://www.usps.com/send/official-abbreviations.htm
    state_name['AE'] = 'Armed Forces Europe'
    state_name['AA'] = 'Armed Forces Americas (except Canada)'
    state_name['AP'] = 'Armed Forces Pacific'
      
    # return the state name.
    puts state_name[abbv]
    if state_name[abbv] == nil
      nil
    else
      state_name[abbv].to_s
    end
      
  end
  
end