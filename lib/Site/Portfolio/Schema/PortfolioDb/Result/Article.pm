use utf8;
package Site::Portfolio::Schema::PortfolioDb::Result::Article;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Site::Portfolio::Schema::PortfolioDb::Result::Article

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<articles>

=cut

__PACKAGE__->table("articles");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 modified

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 cutter

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "modified",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "cutter",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-01-27 19:11:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JvWigWysfpEptDj0KXyspg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
