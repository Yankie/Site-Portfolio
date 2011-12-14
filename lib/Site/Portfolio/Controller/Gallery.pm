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

#     $c->stash->{message} = 'Matched Site::Portfolio::Controller::Gallery in Gallery.';
	$c->go('list', []);
}


=head2 list

=cut

sub list : Local {
	my ($self, $c) = @_;
	my $galleries = $c->model('PortfolioDb::Gallery');
	$c->stash->{galleries} = $galleries;
}

=head2 view

=cut

sub view : Local {
	my ($self, $c, $id) = @_;
	my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $id});
	$c->stash->{gallery} = $gallery;
	my $media = $gallery->media;
}

=head2 add

=cut

sub add : Local FormConfig('gallery/edit.yml') {
	my ($self, $c) = @_;
	$c->go('edit', []);
}

=head2 edit

=cut

sub edit : Local : FormConfig('gallery/edit.yml') {
	my ($self, $c, $id) = @_;
	my $form = $c->stash->{form};
	my $gallery = $c->model('PortfolioDb::Gallery')->find_or_new({id => $id});
	$c->stash->{gallery} = $gallery;
	if ($form->submitted_and_valid) {
		# form was submitted and it validated
		$gallery->title($form->param_value('title'));
		$gallery->description($form->param_value( 'description'));
		$gallery->update_or_insert;
		$c->flash->{success} =  ($id > 0 ? 'Updated ' : 'Added ') . $gallery->title;
		$c->response->redirect($c->uri_for_action('gallery/list'));
		$c->detach();

	}
	else {
		# first time through, or invalid form
		if(!$id){
			$c->stash->{title} = 'Adding a new gallery';
		}
		$form->default_values({'title'  => $gallery->title, 'description' => $gallery->description});
	}
}

=head2 delete

=cut

sub delete : Local {
	my ($self, $c, $id) = @_;
	my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $id});
	$c->stash->{gallery} = $gallery;
	if($gallery){
		$c->flash->{success} = 'Deleted '. $gallery->title;
		$gallery->delete;
	}
	else {
		$c->flash->{error} = "No such gallery - $id";
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
