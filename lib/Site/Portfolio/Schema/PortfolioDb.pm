package Site::Portfolio::Schema::PortfolioDb;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-10 17:48:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cKGDNIQvfmeqeq1dLR+rTA

# exec to update
#  ./script/site_portfolio_create.pl Model PortfolioDb DBIC::Schema Site::Portfolio::Schema::PortfolioDb create=static dbi:mysql:dbname=PhotoGalleryDB pg 4rtyuehe


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
