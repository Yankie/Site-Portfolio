package Site::Portfolio::Controller::Gallery;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

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

=head2 add

=cut

sub add : Local Form('/gallery/edit') {
my ($self, $c) = @_;
$c->go('edit', []);
}

=head2 edit

=cut

sub edit : Local Form {
	my ($self, $c, $id) = @_;
	my $form = $self->formbuilder;
	my $gallery = $c->model('PortfolioDb::Gallery')->find_or_new({id => $id});
	if ($form->submitted && $form->validate) {
		# form was submitted and it validated
		$gallery->title($form->field('title'));
		$gallery->description($form->field( 'description'));
		$gallery->update_or_insert;
		$c->flash->{message} =  ($id > 0 ? 'Updated ' : 'Added ') . $gallery->title;
		$c->response->redirect($c->uri_for_action('gallery/list'));
		$c->detach();

	}
	else {
		# first time through, or invalid form
		if(!$id){
			$c->stash->{message} = 'Adding a new gallery';
		}
		$form->field(name => 'title', value => $gallery->title);
		$form->field(name => 'description', value => $gallery->description);
	}
}

=head2 delete

=cut

sub delete : Local {
	my ($self, $c, $id) = @_;
	my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $id});
	$c->stash->{gallery} = $gallery;
	if($gallery){
		$c->flash->{message} = 'Deleted '. $gallery->title;
		$gallery->delete;
	}
	else {
		$c->flash->{error} = "No gallery $id";
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

__PACKAGE__->meta->make_immutable;

1;
