class ApplicationController < ActionController::Base

    # to resolve 'Can't verify CSRF token authenticity' error
    protect_from_forgery with: :null_session
end
