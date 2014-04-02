# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_simple_and_restful_session',
  :secret      => 'd406a35c6381760317c7baadd5adeb6abbf53a2c6a88ac3b7d256fcaec1c55175a182fb32b34fb1929b7546afd915d31f30ba5beb09c9917a0067a8019af9c8b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
