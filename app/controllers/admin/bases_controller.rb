#FIXME_AB: Admin::BaseController
class Admin::BasesController < ApplicationController
  layout 'admin'
  include AdminAuthorization
  before_action :authenticate, :authorize_admin
end
