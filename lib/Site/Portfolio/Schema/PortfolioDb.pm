use utf8;
package Site::Portfolio::Schema::PortfolioDb;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-02-14 00:12:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C590zb4gDohuf9ShdkONBA

# exec to update
#  ./script/site_portfolio_create.pl Model PortfolioDb DBIC::Schema Site::Portfolio::Schema::PortfolioDb create=static dbi:mysql:dbname=PhotoGalleryDB pg 4rtyuehe


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
