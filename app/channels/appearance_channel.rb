class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    # current_user.update(status: User.statuses[:online])
    # stream_from "some_channel"
    stream_from 'appearance_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_stream_from 'appearance_channel'
    offline
  end

  def online
    broadcast_new_status(User.statuses[:online])
  end

  def away
    broadcast_new_status(User.statuses[:away])
  end

  def offline
    broadcast_new_status(User.statuses[:offline])
  end

  def receive(data)
    ActionCable.server.broadcast('appearance_channel', data)  
  end

  private

  def broadcast_new_status(status)
    current_user.update!(status: status)   # updated through devise --- update current_user status
  end # => User model => after_update_commit => #broadcast_update => replace partial status => partial status grabs #status_to_css 
end
