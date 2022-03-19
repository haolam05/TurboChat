class ApplicationController < ActionController::Base
    include Pagy::Backend

    before_action :turbo_frame_request_variant
    before_action :configure_permitted_parameters, if: :devise_controller?

    private

    def turbo_frame_request_variant
        request.variant = :turbo_frame if turbo_frame_request?
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
end
