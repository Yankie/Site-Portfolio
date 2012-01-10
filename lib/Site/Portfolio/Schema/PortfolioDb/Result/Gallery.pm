package Site::Portfolio::Schema::PortfolioDb::Result::Gallery;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Site::Portfolio::Schema::PortfolioDb::Result::Gallery

=cut

__PACKAGE__->table("gallery");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-10 17:50:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l76QGOBpnglSoHUZqvSgww

__PACKAGE__->load_components("PK::Auto", "Core");

__PACKAGE__->has_many(
	media => 'Site::Portfolio::Schema::PortfolioDb::Result::Media', 'gid', {cascading_delete => 1}
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
