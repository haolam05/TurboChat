class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create(content: msg_params[:content], room_id: params[:room_id])
    @single_room = Room.find(params[:room_id])
  end

  def destroy
    @message.destroy
  end

  private

  def msg_params
    params.require(:message).permit(:content)
  end
end