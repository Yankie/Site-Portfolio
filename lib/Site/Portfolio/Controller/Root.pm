package Site::Portfolio::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }
extends 'Catalyst::Controller::HTML::FormFu';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Site::Portfolio::Controller::Root - Root Controller for Site::Portfolio

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;
	if ($c->config->{start_page}) {
		$c->response->redirect( $c->uri_for($c->config->{start_page}) );
		$c->detach();

	}
	else {
		$c->stash->{media} = $c->model('PortfolioDb::Media');
		$c->stash->{page_title} = $c->loc( 'page.main.title' );
		$c->stash->{page_message} = $c->loc( 'page.main.message [_1] [_2]', $c->uri_for('/gallery'), $c->uri_for('/blog') );
	}


}

sub begin :Private {
my ($self, $c) = @_;
	if ($_ = scalar $c->req->param("lang") ) {
		$c->languages( [$_] );
	}
	if ($c->debug) {
		my $languages = $c->languages;
		$c->log->debug( "Languages setting: " . Data::Dump::dump($languages) );
	}

}
=head2 blog

=cut

# sub blog :Local {
# my ($self, $c) = @_;
# }

=head2 contact

=cut

sub contact :Local  : FormConfig('contact.yml'){
	my ($self, $c) = @_;
	$c->stash->{page_title} = $c->loc( 'ui.menu.link.contacts' );
	$c->stash->{messages} = $c->model('PortfolioDb::Feedback');
	my $form = $c->stash->{form};
	if ($form->submitted_and_valid) {
		# form was submitted and it validated
		my $feedback = $c->model('PortfolioDb::Feedback')->create({
			name		=> $form->param_value('name'),
			email		=> $form->param_value('email'),
			message	=> $form->param_value('message'),
			created	=> DateTime->now
		});
		$c->flash->{success} = $c->loc( 'ui.message.feedback.add.success' );
		$c->response->redirect( $c->uri_for('/') );
		$c->detach();
	}
	else {
		# first time through, or invalid form
# 		$form->default_values({'title'  => $gallery->title, 'description' => $gallery->description});
	}
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'not_found.tt2';
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
	my ( $self, $c ) = @_;
	my $galleries = $c->model('PortfolioDb::Gallery');
	$c->stash->{menu} = $galleries;
	$c->stash->{ENV} = \%ENV;

}

sub access_denied : Private {
	my ($self, $c) = @_;
	$c->stash->{template} = 'denied.tt2';
}

=head1 AUTHOR

Pavel Yefimov

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
