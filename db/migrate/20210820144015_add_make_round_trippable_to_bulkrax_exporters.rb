class AddMakeRoundTrippableToBulkraxExporters < ActiveRecord::Migration[5.1]
  def change
    add_column :bulkrax_exporters, :make_round_trippable, :boolean
  end
end
