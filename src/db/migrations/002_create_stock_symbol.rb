Sequel.migration do
  up do
    create_table(:stock_symbol) do
      primary_key :id
      String :symbol
      String :sub_symbol_1
      String :sub_symbol_2
      String :company_name
      DateTime :created_at
      DateTime :updated_at
      Fixnum :sector_id
      Fixnum :industry_id
      Fixnum :exchange_id   
    end
  end

  down do
    drop_table(:stock_symbol)
  end
end