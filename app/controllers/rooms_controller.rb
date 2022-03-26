class RoomsController < ApplicationController
  include RoomsHelper

  before_action :set_user_name
  before_action :authenticate_user!
  before_action  :set_status

  def search
    # @rooms = Room.public_rooms.where('name ILIKE ?', "%#{params[:name_search]}%").order(name: :asc)
    @rooms = search_rooms # moved logic into rooms_helper

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ 
          turbo_stream.update("search_results", partial: "rooms/search_results", locals: { rooms: @rooms }) 
        ]
      end
    end
  end

  def join
    @room = Room.find(params[:id])
    current_user.joined_rooms << @room
    redirect_to @room
  end

  def leave
    @room = Room.find(params[:id])
    current_user.joined_rooms.delete(@room)
    redirect_to rooms_path
  end

  def index      
    @room = Room.new
    @joined_rooms = current_user.joined_rooms.order('last_message_at DESC')
    @rooms = search_rooms
    @users = User.all_except(@current_user)
    
    render 'index'
  end

  def show
    @room = Room.new
    @users = User.all_except(current_user)
    @joined_rooms = current_user.joined_rooms.order('last_message_at DESC')
    @rooms = search_rooms
    @single_room = Room.find(params[:id])

    @message = Message.new
    
    pagy_messages = @single_room.messages.includes(:user).order(created_at: :desc)  # open room => #show action => show action render index page => room index page has access to @pagy
    @pagy, messages = pagy(pagy_messages, items: 20)                                # get latest 10 messages
    @messages = messages.reverse

    opentok = OpenTok::OpenTok.new Rails.application.credentials.vonage_api_key, Rails.application.credentials.vonage_api_secret
    @token = opentok.generate_token @single_room.vonage_session_id, { name: current_user.name }

    render 'index'
  end

  def create
    if params['room'].nil?
      redirect_to rooms_url, alert: "Missing Room Name" if params['name'].empty? 
      @room = Room.create(name: params['name'])
    else
      redirect_to rooms_url, alert: "Missing Room Name"  if params['room']['name'].empty?
      @room = Room.create(name: params['room']['name'])
    end
  end

  private

  def set_status
    current_user.update!(status: User.statuses[:online]) if current_user
  end
  # def destroy
  #   @room = Room.find(params[:room_id])
  #   # if @room.user
  #   @messages.where(room_id: params[:room_id])
  #   @messages.each { |mesage| message.destroy }
  #   @room.destroy
  #   redirect_to rooms_path, notice: "Room was successfully deleted"
  # end

  def set_user_name
    current_user.update!(name: "") if current_user && current_user.name.nil?
  end
end

    # Message.where(room_id: params[:id]).each { |mess| Message.destroy(mess.id) }
    # Room.destroy(params[:id]

