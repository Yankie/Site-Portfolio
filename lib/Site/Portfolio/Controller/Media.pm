package Site::Portfolio::Controller::Media;

use strict;
use warnings;

use Moose;
use namespace::autoclean;

use DateTime;
use Imager;
use MIME::Types;
use Data::Dumper;

BEGIN {extends 'Catalyst::Controller'; }
extends 'Catalyst::Controller::HTML::FormFu';

our $mimeinfo = {
	'image/x-ms-bmp' => 'bmp',
	'image/gif' => 'gif',
	'image/vnd.microsoft.icon' => 'ico',
	'image/jpeg' => 'jpeg',
	'image/png' => 'png',
	'image/x-portable-anymap' => 'pnm',
	'image/vnd.sealedmedia.softseal.gif' => 'sgi',
	'image/targa' => 'tga',
};

=head1 NAME

Site::Portfolio::Controller::Media - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
use Data::Dumper;
sub index :Path :Args(0) {
	my ( $self, $c ) = @_;

	my $media = $c->model('PortfolioDb::Media');

	$c->stash->{page_title} = $c->loc('page.media.title');#"All media";
	$c->stash->{page_message} = $c->loc('page.media.message');
	
	$c->stash->{media} = $media;
	$c->stash->{per_page} = 12;
}

=head2 add

  Add a media to the database

=cut

sub add : Local FormConfig('media/add.yml') {
	my ($self, $c, $gid) = @_;
	my $form = $c->stash->{form};

	my $mime = MIME::Types->new;
	my $media;
	
	## Check Authorization 
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {
		$c->flash->{error} = $c->loc('ui.error.media.no.add.permissions'); #"You don't have proper permissions to add photos here";
		$c->response->redirect( $c->uri_for_action('/media') );
		$c->detach();
	}
	# we're adding a new media to gallery or outside all galleries
	# check that gallery defined and exists
	my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $gid});
	if (!$gid) {
		$c->flash->{warning} =$c->loc('ui.warning.media.add.wrong.gallery'). $c->loc('ui.warning.media.add.root.gallery'); #'No gallery selected! Uploading to root...';
	}
	elsif (!$gallery) {
		$c->flash->{warning} = $c->loc('ui.warning.media.add.no.gallery'). $c->loc('ui.warning.media.add.root.gallery'); #'No such gallery! Uploading to root...';
	}
	# create the new media
	if ( $form->submitted_and_valid ) {
	
		$media = $c->model('PortfolioDb::Media')->create(
			{
				title			=> $form->param('title'),
				path			=> $c->req->upload('media')->fh,
				description	=> $form->param('description'),
				uploaded		=> DateTime->now,
				mime			=> $mime->mimeTypeOf( $c->req->upload('media')->basename ),
				gid			=> $gid,
			}
		);
		my $data = $media->path->open('r') or die "Error: $!";
		my $img = Imager->new;
		my $mime = MIME::Types->new;
		my $out;

		$img->read( fh => $data ) or die $img->errstr;

		my $xsize;
		my $ysize;
		# Generate thumbnail
		$xsize  = $c->config->{thumbnail_width} || $c->config->{thumbnail_size} || 50;
		$ysize  = $c->config->{thumbnail_height} || $c->config->{thumbnail_size} || 50;

		my $img1 = $img->scale( xpixels => $xsize, ypixels => $ysize, type=>'max', qtype => 'mixing' ); #->crop(width=>$size, height=>$size);
		
		$img1->write(
			type => 'jpeg',
			file => $c->path_to($c->config->{local_static}, 'static', 'thumbnails')."/".$media->id.".jpg"
		) or die $img->errstr;
		# Generate preview
		$xsize  = $c->config->{preview_width} || $c->config->{preview_size} || 640;
		$ysize  = $c->config->{preview_height} || $c->config->{preview_size} || 480;

		my $img2 = $img->scale( xpixels => $xsize, ypixels => $ysize, type=>'max', qtype => 'mixing' )->crop(width=>$xsize, height=>$ysize);

		$img2->write(
			type => 'jpeg',
			file => $c->path_to($c->config->{local_static}, 'static', 'previews')."/".$media->id.".jpg"
		) or die $img->errstr;
		# Generate view
		$xsize  = $c->config->{view_width} || $c->config->{view_size} || 800;
		$ysize  = $c->config->{view_height} || $c->config->{view_size} || 600;

		my $img3 = $img->scale( xpixels => $xsize, ypixels => $ysize, type=>'max', qtype => 'mixing' ); #->crop(width=>$size, height=>$size);

		$img3->write(
			type => 'jpeg',
			file => $c->path_to($c->config->{local_static}, 'static', 'views')."/".$media->id.".jpg"
		) or die $img->errstr;

		
		$c->flash->{success} =  $c->loc( 'ui.message.media.add.success [_1] [_2]', $media->title, ($gid ? $media->gid->title : 'root'));
		$c->response->redirect(($gid ? $c->uri_for_action('gallery/view', $media->gid->id) : '/media'));
		$c->detach();
	}
	else {
		$media = $c->model('PortfolioDb::Media')->new({gid => $gid});
		# transfer data from database to form
		$c->stash->{media} = $media;
		$c->stash->{page_title} = $c->loc('page.media.add.title [_1]', ($media->gid ? $media->gid->title : 'root'));
		$c->stash->{page_message} = $c->loc('page.media.add.message [_1]', ($media->gid ? $media->gid->title : 'root'));
		$form->default_values({'title'  => $media->title, 'description' => $media->description});
	}
}

sub edit : Local Args(1) FormConfig('media/edit.yml') {
	my ($self, $c, $id) = @_;

 	my $form = $c->stash->{form};
	
	## comment out this block if you're not using the Authorization plugin
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {
		$c->flash->{error} = $c->loc('ui.error.media.no.edit.permissions'); #"You don't have proper permissions to edit photos here";
		$c->response->redirect( '/gallery/list' );
		$c->detach();
	}

	my $mime = MIME::Types->new;
	my $media = $c->model('PortfolioDb::Media')->find({id => $id});
# 	my $media = $c->stash->{media};
	if (!$media) {
		$c->flash->{error} = $c->loc('ui.error.media.no'); #'No such media!';
		$c->response->redirect( '/media' );
		$c->detach();
	}

	if ( $form->submitted_and_valid ) {
		$media->title( $form->param_value('title'));
		$media->description($form->param_value('description'));
		$media->update;
		$c->flash->{success} =  $c->loc( 'ui.message.media.update.success [_1] [_2]', $media->title, ($media->gid ? $media->gid->title : 'root'));
		$c->response->redirect(($media->gid ? $c->uri_for_action('gallery/view', $media->gid->id) : '/media'));
		$c->detach();
	}
	else {
		# transfer data from database to form
		$c->stash->{media} = $media;
		$c->stash->{page_title} = $c->loc('page.media.edit.title [_1] [_2]', $media->title, ($media->gid ? $media->gid->title : 'root'));
		$c->stash->{page_message} = $c->loc('page.media.edit.message [_1] [_2]', $media->title, ($media->gid ? $media->gid->title : 'root'));
		$form->default_values({'title'  => $media->title, 'description' => $media->description});
	}
}



=head2 delete

  delete a photo or photos

=cut

sub delete : Local Args(1) {
	my ( $self, $c, $id ) = @_;
	my $media = $c->model('PortfolioDB::Media')->find($id);

	unless ( defined $media ) {
		$c->flash->{error} = $c->loc('ui.error.media.no'); #"No such media.";
		$c->response->redirect($c->uri_for_action('gallery/list'));
		$c->detach();

	}

	if ( $c->can('check_user_roles') && !$c->check_user_roles("admin") ) {
		$c->flash->{error} =  $c->loc('ui.error.media.no.delete.permissions'); #"You don't have proper permissions to delete images.";
		$c->response->redirect(($media->gid ? $c->uri_for_action('gallery/view', $media->gid->id) : '/media'));
	}
	else {
# 		if ( $c->req->param('delete') eq 'yes' ) {
		$c->flash->{success} = $c->loc( 'ui.message.media.delete.success [_1] [_2]', $media->title, ($media->gid ? $media->gid->title : 'root')); # "Media " . $media->id . " deleted!";
		$c->response->redirect(($media->gid ? $c->uri_for_action('gallery/view', $media->gid->id) : '/media'));
		# delete all generated images
		foreach (qw(thumbnails previews views)) {
			unlink($c->path_to($c->config->{local_static}, 'static', $_, $media->id.'.jpg'));
		}
		$media->delete;
# 		}
	}
}

=head1 AUTHOR

Pavel Yefimov,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
