Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook,"253970248019703","bdcf0fcf2b14c2ffc7a93ab4ca64400b", {:client_options => {:ssl => {:ca_path => "#{$RAILS_ROOT}/cacert.pem"}}}
end