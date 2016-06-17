class AddressesController < ApplicationController

  def create
    @address = current_user.addresses.build(address_params)
    @save_success = @address.save
  end

  def address_params
    params.permit(:house_no, :street, :city, :pincode)
  end

end
