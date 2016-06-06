CONSTANTS = YAML.load_file(File.expand_path('../constants.yml', __FILE__))[Rails.env]
REGEX = {permalink: /\A[a-zA-Z0-9\-]+\Z/,
  image_url: %r{\.(gif|jpg|png)\Z}i,
  email: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }



#FIXME_AB: move to yml
# PASSWORD_TOKEN_EXPIRES_IN = 3

DAILY_PUBLISH_TIME = 10

MIN_TIME_TO_PUBLISH = 24

MINIMUM_PUBLISHABILITY_QUANTITY = 10

MINIMUM_PUBLISHABLE_IMAGES = 2

MAX_DEALS_PER_DAY = 2
