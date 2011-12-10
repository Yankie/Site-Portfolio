package Site::Portfolio::Controller::Media;
use Moose;
use namespace::autoclean;
use Imager;
use MIME::Types;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Site::Portfolio::Controller::Media - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{message} = 'Matched Site::Portfolio::Controller::Media in Media.';
}


=head1 AUTHOR

Pavel Yefimov,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
