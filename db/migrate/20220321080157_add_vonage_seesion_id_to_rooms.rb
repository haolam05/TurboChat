class AddVonageSeesionIdToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :vonage_session_id, :string
  end
end
