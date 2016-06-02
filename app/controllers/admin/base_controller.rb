class Admin::BaseController < ApplicationController
  layout 'admin'
  include AdminAuthorization
  before_action :authenticate, :authorize_admin
end
