Sequel.migration do
  up do
    create_table(:exchange) do
      primary_key :id
      String :symbol
      String :name
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:exchange)
  end
end