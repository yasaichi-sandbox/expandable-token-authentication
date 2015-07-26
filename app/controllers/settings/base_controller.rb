class Settings::BaseController < ApplicationController
  before_action :authenticate_user!
end
