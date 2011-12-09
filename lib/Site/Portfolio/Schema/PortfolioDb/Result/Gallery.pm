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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-12-09 18:56:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T1D7B8oLDiiDJcuhxFIgTA

__PACKAGE__->has_many(
	media => 'Site::Portfolio::Schema::PortfolioDb::Result::Media', 'gid', {cascading_delete => 1}
);

__PACKAGE__->meta->make_immutable;
1;
