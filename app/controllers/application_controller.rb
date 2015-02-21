class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_options

  def load_options
    @states ||= State.all
    @providers ||= Provider.order(:nombre_completo).all
  end
end
