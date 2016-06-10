Rails.configuration.stripe = {
  :publishable_key => CONSTANTS['publishable_key'],
  :secret_key      => CONSTANTS['secret_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
