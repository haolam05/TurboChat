class UsersController < ApplicationController
    include RoomsHelper
    
    def show
        @user = User.find(params[:id])
        @users = User.all_except(current_user)

        @room = Room.new
        @joined_rooms = current_user.joined_rooms
        @rooms = search_rooms
        @room_name = get_name(@user, current_user)
        
        @message = Message.new
        @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, current_user], @room_name)
        
        pagy_messages = @single_room.messages.includes(:user).order(created_at: :desc)
        @pagy, messages = pagy(pagy_messages, items: 20)              # get latest 10 messages
        @messages = messages.reverse
        
        opentok = OpenTok::OpenTok.new Rails.application.credentials.vonage_api_key, Rails.application.credentials.vonage_api_secret
        @token = opentok.generate_token @single_room.vonage_session_id, { name: current_user.name }

        render 'rooms/index'
    end

    private

    # create a unique name for the private room(of 2 users)
    def get_name(user1, user2)
        users_ids = [user1, user2].sort
        "private_#{users_ids.first.id}_#{users_ids.last.id}"    # private_1_2 == private_2_1 => sort
    end
end