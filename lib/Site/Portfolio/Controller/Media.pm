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

# 	my $page = $c->request->param('page');
# 	$page = 1 if($page !~ /^\d+$/);

# 	my $media = $c->model('PortfolioDb::Media')->search({}, {rows=>12, page => $page});
	my $media = $c->model('PortfolioDb::Media');
# 	$media = $media->page($page);

# 	my $pager = $media->pager;

	$c->stash->{title} = "All media";
	$c->stash->{media} = $media;
	$c->stash->{per_page} = 12;
# 	$c->stash->{pager} = $pager;
	
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
		$c->flash->{error} = "You don't have proper permissions to add photos here";
		$c->response->redirect( $c->uri_for_action('/media') );
	}
	# we're adding a new media to gallery or outside all galleries
	# check that gallery defined and exists
	my $gallery = $c->model('PortfolioDb::Gallery')->find({id => $gid});
	if (!$gid) {
		$c->flash->{warning} = 'No gallery selected! Uploading to root...';
	}
	elsif (!$gallery) {
		$c->flash->{warning} = 'No such gallery! Uploading to root...';
	}
	# create the new media
	

	if ( $form->submitted_and_valid ) {
	
		$media = $c->model('PortfolioDb::Media')->create(
			{
				title		=> $form->param('title'),
				path		=> $c->req->upload('media')->fh,
				description	=> $form->param('description'),
				uploaded	=> DateTime->now,
				mime		=> $mime->mimeTypeOf( $c->req->upload('media')->basename ),
				gid			=> $gid,
			}
		);
	
# 		$media->title( $form->param('title'));
# 		$media->description($form->param('description'));
# 		$media->uploaded(DateTime->now);
# 		
# 		$media->path($c->request->upload('media')->fh);
# 		$media->mime($mime->mimeTypeOf( $c->request->upload('media')->basename ));
		
		$c->flash->{success} =  'Added new ' . $media->title . ' media for ' . ($gid ? $media->gid->title : 'root');
		$c->response->redirect(($gid ? $c->uri_for_action('gallery/view', $gid) : '/media'));
		$c->detach();
	}
	else {
		$media = $c->model('PortfolioDb::Media')->new({gid => $gid});
		# transfer data from database to form
		$c->stash->{media} = $media;
		$c->stash->{title} = 'Adding a new media';
		$c->stash->{title} .= ' for '. $media->gid->title if $gid;
		$form->default_values({'title'  => $media->title, 'description' => $media->description});
	}
}

sub edit : Local FormConfig('media/edit.yml') {
	my ($self, $c, $id, $gid) = @_;

 	my $form = $c->stash->{form};
	
	## comment out this block if you're not using the Authorization plugin
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {

		$c->flash->{error} =
		"You don't have proper permissions to add photos here";
		$c->response->redirect( 'media' );

	}

	my $mime = MIME::Types->new;
	my $media = $c->model('PortfolioDb::Media')->find({id => $id});
	if (!$media) {
		$c->flash->{error} = 'No such media!';
		$c->response->redirect( 'media' );
		$c->detach();
	}

	if ( $form->submitted_and_valid ) {
		$media->title( $form->param('title'));
		$media->description($form->param('description'));
		$c->flash->{success} =  'Updated ' . $media->title . ' media for ' . ($gid ? $media->gid->title : 'root');
		$c->response->redirect(($gid ? $c->uri_for_action('gallery/view', $gid) : '/media'));
		$c->detach();
	}
	else {
		# transfer data from database to form
		$c->stash->{media} = $media;
		$c->stash->{title} = 'Updating a media';
		$c->stash->{title} .= ' for '. $media->gid->title if $gid;
		$form->default_values({'title'  => $media->title, 'description' => $media->description});
	}
}

=head2 get_media

  set up media stash

=cut

sub get_media : Chained('/') PathPart('media') CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;

	my $media = $c->model('PortfolioDB::Media')->find($id);

	unless ( defined $media ) {

		$c->stash->{error} = "No such media.";

	}
	else {

		$c->stash->{media} = $media;

	}

}

=head2 generate_thumbnail

  this method generates a thumbnail of a
  given image

=cut

sub generate_thumbnail : Chained('get_media') PathPart('thumbnail') Args(0) {
	my ( $self, $c, $type ) = @_;
	my $media = $c->stash->{media};
	my $size  = $c->config->{thumbnail_size} || 50;
	my $data = $media->path->open('r') or die "Error: $!";
	my $img = Imager->new;
	my $mime = MIME::Types->new;
	my $out;
	$type = $mime->mimeTypeOf( $type || 'jpeg') || 'image/jpeg';

	$img->read( fh => $data ) or die $img->errstr;
	$img = $img->scale( xpixels => $size, ypixels => $size, type=>'max', qtype => 'mixing' ); #->crop(width=>$size, height=>$size);
	
	$img->write(
		type => $mimeinfo->{ $type },
		data => \$out
	) or die $img->errstr;
	$c->res->content_type( $type );
	$c->res->content_length( -s $out );
	$c->res->header( "Content-Disposition" => "inline; filename=" . $type );

	binmode $out;
	$c->res->body($out);
}

=head2 view_media

  hackish method to view
  an image full-size

=cut
sub view_media : Chained('get_media') PathPart('generate') Args(0){
	my ($self, $c) = @_;
	$c->go('view_media_type', undef);
}

sub view_media_type : Chained('get_media') PathPart('generate') Args(1) {
	my ( $self, $c, $type ) = @_;
	my $media = $c->stash->{media};
	my $size  = $c->config->{view_size} || 300;
	my $data = $media->path->open('r') or die "Error: $!";
	my $mime = MIME::Types->new;
	my $img = Imager->new;
	my $out;
	$type = $mime->mimeTypeOf( $type || 'jpeg') || 'image/jpeg';

	$c->log->debug("Image type requested: $type");

	$img->read( fh => $data ) or die $img->errstr;
	$img = $img->scale( xpixels => $size, ypixels => $size, type=>'min', qtype => 'mixing' );
	$img->write(
		type => $mimeinfo->{ $type },
		data => \$out
	) or die $img->errstr;
	$c->res->content_type(  $type  );
	$c->res->content_length( -s $out );
	$c->res->header( "Content-Disposition" => "inline; filename=" . $type );

	binmode $out;
	$c->res->body($out);
}

=head2 preview_media

  hackish method to view
  an image full-size

=cut

sub preview_media : Chained('get_media') PathPart('slideshow') Args(0) {
	my ( $self, $c, $type) = @_;
	my $media = $c->stash->{media};
	my $xsize  = $c->config->{slideshow_width} || 719;
	my $ysize  = $c->config->{slideshow_height} || 442;
	my $data = $media->path->open('r') or die "Error: $!";
	my $mime = MIME::Types->new;
	my $img = Imager->new;
	my $out;
	$type = $mime->mimeTypeOf( $type || 'jpeg') || 'image/jpeg';

	$img->read( fh => $data ) or die $img->errstr;
	$img = $img->scale( xpixels => $xsize, ypixels => $ysize, type=>'max', qtype => 'mixing' )->crop(width=>$xsize, height=>$ysize);
	$img->write(
		type => $mimeinfo->{ $type },
		data => \$out
	) or die $img->errstr;

# 	$c->res->content_type( $media->mime );
	$c->res->content_type( $type );
	$c->res->content_length( -s $out );
	$c->res->header( "Content-Disposition" => "inline; filename=" . $type );

	binmode $out;
	$c->res->body($out);
}

=head2 view_photo

  view an individual media

=cut

sub view_photo : Chained("get_media") PathPart('view') Args(0) {
	my ( $self, $c ) = @_;

	my $media = $c->stash->{media};

	$c->stash->{template} = "media/view.tt2";

}

=head2 delete_photo

  delete a photo or photos

=cut

sub delete_media : Chained("get_media") PathPart('delete') Args(0) {
	my ( $self, $c ) = @_;

	my $media = $c->stash->{media};
	$c->stash->{template} = 'media/delete.tt2';

	if ( $c->can('check_user_roles') && !$c->check_user_roles("admin") ) {
		$c->flash->{error} =  "You don't have proper permissions to delete images.";
		$c->res->redirect("/media");
	}
	else {
		if ( $c->req->param('delete') eq 'yes' ) {

			$media->delete;
			$c->stash->{success} = "Media " . $media->id . " deleted!";
			$c->detach;

		}

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
