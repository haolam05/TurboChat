module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # make connection to devise user so that we can make change to user's staus based on JS frontend events
    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end