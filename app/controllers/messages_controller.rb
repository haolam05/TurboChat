class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create(content: msg_params[:content], room_id: params[:room_id], attachments: msg_params[:attachments])
    @single_room = Room.find(params[:room_id])
  end

  private

  def msg_params
    params.require(:message).permit(:content, attachments: [])
  end
end