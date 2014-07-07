Sequel.migration do
  up do
    create_table(:industry) do
      primary_key :id
      String :name
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:industry)
  end
end