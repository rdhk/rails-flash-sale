class AddressesController < ApplicationController
  #FIXME_AB: who can create an address? - done
  before_action :authenticate

  def create
    @address = current_user.addresses.build(address_params)
    @save_success = @address.save
  end

  #FIXME_AB: private? - done
  private

  def address_params
    params.permit(:house_no, :street, :city, :pincode)
  end

end
