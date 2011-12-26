package Site::Portfolio;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
	-Debug
	ConfigLoader
	Static::Simple
	Unicode::Encoding
	Session
	Session::State::Cookie
	Session::Store::FastMmap
	Authentication
	Authorization::Roles
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in site_portfolio.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
	name => 'Site::Portfolio',
	'Plugin::ConfigLoader' => {
		driver => {
			'General' => { -UTF8 => 1 },
		},
	},
	encoding => 'UTF-8',
	session => {
		flash_to_stash => 1
	},
	# Disable deprecated behavior needed by old applications
	disable_component_resolution_regex_fallback => 1,
	# Send X-Catalyst header
	enable_catalyst_header => 1,
);

__PACKAGE__->config( 'Plugin::Authentication' =>
{
	default => {
		credential => {
			class => 'Password',
			password_field => 'password',
			password_type => 'clear'
		},
		store => {
			class => 'Minimal',
			users => {
				admin => {
					password => "123",
					 editor => 'yes',
					 roles => [qw/admin create edit delete/],
				},
			}
		}
	}
}
);

# Start the application
__PACKAGE__->setup();

## Apply theme paths
__PACKAGE__->config->{static}->{include_path} = [__PACKAGE__->config->{root}, __PACKAGE__->path_to('root','themes',__PACKAGE__->config->{theme} )];


=head1 NAME

Site::Portfolio - Catalyst based application

=head1 SYNOPSIS

	script/site_portfolio_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Site::Portfolio::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Pavel Yefimov

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
