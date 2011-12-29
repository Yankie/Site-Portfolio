package Site::Portfolio::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }
extends 'Catalyst::Controller::HTML::FormFu';


=head1 NAME

Site::Portfolio::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 access_denied

=cut

sub access_denied : Private {
	my ($self, $c) = @_;
	$c->stash->{template} = 'denied.tt2';
}

=head2 login

=cut

sub login : Global FormConfig {
	my ($self, $c) = @_;
	my $form = $c->stash->{form};
	$c->stash->{page_title} = $c->loc( 'ui.menu.link.admin' );
	
	return unless $form->submitted_and_valid;
	if ($c->authenticate({
			username => $form->param_value('username'),
			password => $form->param_value('password'),
		})) 	{
		$c->flash->{success} = $c->loc('ui.message.login.success');
		$c->res->redirect($c->uri_for('/'));
		$c->detach();
	}
	else {
		$c->flash->{error} = $c->loc('ui.message.login.fail');
		$c->res->redirect($c->uri_for('/'));
		$c->detach();
	}
}

=head2 logout

=cut

sub logout : Global {
	my ($self, $c) = @_;
	$c->logout;
	$c->flash->{success} = $c->loc('ui.message.logout');
	$c->res->redirect($c->uri_for('/'));
}


=head2 index

=cut

# sub index :Path :Args(0) {
#     my ( $self, $c ) = @_;
# 
#     $c->response->body('Matched Site::Portfolio::Controller::Auth in Auth.');
# }


=head1 AUTHOR

Pavel Yefimov

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
