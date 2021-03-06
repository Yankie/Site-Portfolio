package Site::Portfolio::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        Site::Portfolio->path_to( 'etc', 'themes', Site::Portfolio->config->{theme}, 'src' ),
        Site::Portfolio->path_to( 'etc', 'themes', Site::Portfolio->config->{theme}, 'lib' ),
        Site::Portfolio->path_to( 'etc', 'themes', 'default', 'src' ),
        Site::Portfolio->path_to( 'etc', 'themes', 'default', 'lib' ),
    ],
    DEFAULT_ENCODING   => 'utf-8',
    TEMPLATE_EXTENSION => '.tt2',
    PRE_PROCESS        => 'config/main',
    WRAPPER            => 'site/wrapper',
    ERROR              => 'error.tt2',
    TIMER              => 0,
    render_die         => 1,
    ENCODING           => "UTF-8",
});

use Template::Filters;
$Template::Filters::FILTERS->{escape_js_string} = \&escape_js_string;
sub escape_js_string {
  my $s = shift;
  $s =~ s/(\\|'|"|\/)/\\$1/g;
  return $s;
}
1;

=head1 NAME

Site::Portfolio::View::HTML - Catalyst TTSite View

=head1 SYNOPSIS

See L<Site::Portfolio>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Pavel Yefimov

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

