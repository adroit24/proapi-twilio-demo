require './lib/application'

$stdout.sync = true
$stderr.sync = true # eventually

run WP::SaladTwilioApp::Application

