# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tr8n_examples_session',
  :secret      => '68d034ebb82db992add6994df56a510f6ef304e9e5bd5504e6345ae2a8e550edf30c8807fccb424505434e6a59c5a94935dc677b39baf27652256da84af49f3b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
