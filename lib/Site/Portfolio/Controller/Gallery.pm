package Site::Portfolio::Controller::Gallery;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }
extends 'Catalyst::Controller::HTML::FormFu';

=head1 NAME

Site::Portfolio::Controller::Gallery - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;

    $c->stash->{page_title} = $c->loc('page.gallery.title');
    $c->stash->{page_message} = $c->loc('page.gallery.message');
	$c->go('list', []);
}


=head2 list

=cut

sub list : Local {
	my ($self, $c) = @_;
	my $galleries = $c->model('PortfolioDb::Gallery');

	$c->stash->{page_title} = $c->loc('page.gallery.list.title');
	$c->stash->{page_message} = $c->loc('page.gallery.list.message');
	$c->stash->{galleries} = $galleries;
}

=head2 view

=cut

sub view : Local {
	my ($self, $c, $id) = @_;
	my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $id});

	$c->stash->{per_page} = 12;
	$c->stash->{gallery} = $gallery;
	$c->stash->{media} = $gallery->media;
	$c->stash->{page_title} = $c->loc('page.gallery.view.title [_1]', $gallery->title);
	$c->stash->{page_message} = $c->loc('page.gallery.view.title [_1]', $gallery->title);
}

=head2 add

=cut

sub add : Local FormConfig('gallery/edit.yml') {
	my ($self, $c) = @_;

	## Check Authorization
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {
		$c->flash->{error} = $c->loc('ui.error.gallery.no.add.permissions'); #"You don't have proper permissions to add photos here";
		$c->response->redirect( $c->uri_for_action('/gallery/list') );
		$c->detach();
	}
	$c->go('edit', []);
}

=head2 edit

=cut

sub edit : Local : FormConfig('gallery/edit.yml') {
	my ($self, $c, $id) = @_;

	## Check Authorization
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {
		$c->flash->{error} = $c->loc('ui.error.gallery.no.edit.permissions'); #"You don't have proper permissions to add photos here";
		$c->response->redirect( $c->uri_for_action(($id ? '/gallery/view' : '/gallery/list'), $id) );
		$c->detach();
	}
	my $form = $c->stash->{form};
	my $gallery = $c->model('PortfolioDb::Gallery')->find_or_new({id => $id});
	$c->stash->{gallery} = $gallery;
	if ($form->submitted_and_valid) {
		# form was submitted and it validated
		$gallery->title($form->param_value('title'));
		$gallery->description($form->param_value( 'description'));
		$gallery->update_or_insert;
		$c->flash->{success} =  ($id > 0 ? $c->loc( 'ui.message.gallery.update.success [_1]', $gallery->title) : $c->loc( 'ui.message.gallery.add.success [_1]', $gallery->title));
		$c->response->redirect($c->uri_for_action('gallery/list'));
		$c->detach();

	}
	else {
		# first time through, or invalid form
		if(!$id){
			$c->stash->{page_title} = $c->loc('page.gallery.add.title');
			$c->stash->{page_message} = $c->loc('page.gallery.add.message');
		}
		else {
			$c->stash->{page_title} = $c->loc('page.gallery.edit.title [_1]', $gallery->title);
			$c->stash->{page_message} = $c->loc('page.gallery.edit.message [_1]', $gallery->title);
		}
		$form->default_values({'title'  => $gallery->title, 'description' => $gallery->description});
	}
}

=head2 delete

=cut

sub delete : Local {
	my ($self, $c, $id) = @_;

	if ( $c->can('check_user_roles') && !$c->check_user_roles("admin") ) {
		$c->flash->{error} =  $c->loc('ui.error.gallery.no.delete.permissions'); #"You don't have proper permissions to delete images.";
	}
	else {

		my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $id});
		$c->stash->{gallery} = $gallery;
		if($gallery){
			$c->flash->{success} = $c->loc('ui.message.gallery.delete.success [_1]', $gallery->title);
			$gallery->delete;
		}
		else {
			$c->flash->{error} = $c->loc('ui.message.gallery.no [_1]', $id ); #"No such gallery - $id";
		}
	}
	$c->response->redirect($c->uri_for_action('gallery/list'));
	$c->detach();
}


=head1 AUTHOR

Pavel Yefimov

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# __PACKAGE__->meta->make_immutable;

1;
