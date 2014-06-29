Sequel.migration do
  up do
    create_table(:stock_quote) do
      primary_key :id
      Date :price_date, :null=>false
      Float :open
      Float :high
      Float :low
      Float :close
      Float :adj_close
      Fixnum :volume
      DateTime :created_at
      DateTime :updated_at
      Fixnum :stock_symbol_id
    end
  end

  down do
    drop_table(:stock_quote)
  end
end