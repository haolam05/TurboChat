module RoomsHelper
  def search_rooms
    if params.dig(:name_search).present? && params.dig(:name_search).length > 0
      Room.public_rooms
          .where.not(id: current_user.joined_rooms.pluck(:id))
          .where('name ILIKE (?)', "%#{params[:name_search]}%")
          .order(name: :asc)
    else
      []
    end
  end

  def search_private_rooms_and_their_users
    private_rooms = Room
                      .where(is_private: true)
                      .order('last_message_at DESC')
                      .select { |room| room.name.include?(current_user.id.to_s) && (room.name.split("_")[1] != room.name.split("_")[2]) }
    
    private_rooms_users = private_rooms.map do |room|
        room_name = room.name.split("_")
        User.find(room_name[1] == current_user.id.to_s ? room_name[2] : room_name[1])
    end
    
    [private_rooms, private_rooms_users]
  end

  def search_private_rooms
    if params.dig(:email_search).present? && params.dig(:email_search).length > 0
      User.where('email ILIKE (?)', "%#{params[:email_search]}%") + User.where('name ILIKE (?)', "%#{params[:email_search]}%")
    end
  end
end