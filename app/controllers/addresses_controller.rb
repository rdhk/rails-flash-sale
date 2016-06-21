class AddressesController < ApplicationController
  before_action :authenticate

  def create
    @address = current_user.addresses.build(address_params)
    @save_success = @address.save
  end

  private

  def address_params
    params.permit(:house_no, :street, :city, :pincode)
  end

end
