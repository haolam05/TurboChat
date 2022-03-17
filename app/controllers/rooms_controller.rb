class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action  :set_status

  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    
    render 'index'
  end

  def show
    @room = Room.new
    @users = User.all_except(current_user)
    @rooms = Room.public_rooms
    @single_room = Room.find(params[:id])

    @message = Message.new

    pagy_messages = @single_room.messages.order(created_at: :asc) # open room => #show action => show action render index page => room index page has access to @pagy
    @pagy, messages = pagy(pagy_messages, items: 20)              # get latest 20 messages
    @messages = messages.reverse

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
end

    # Message.where(room_id: params[:id]).each { |mess| Message.destroy(mess.id) }
    # Room.destroy(params[:id]

