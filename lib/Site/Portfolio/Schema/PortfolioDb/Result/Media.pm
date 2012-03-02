use utf8;
package Site::Portfolio::Schema::PortfolioDb::Result::Media;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Site::Portfolio::Schema::PortfolioDb::Result::Media

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

=head1 TABLE: C<media>

=cut

__PACKAGE__->table("media");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 gid

  data_type: 'integer'
  is_nullable: 1

=head2 position

  data_type: 'integer'
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 mime

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 uploaded

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 path

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "gid",
  { data_type => "integer", is_nullable => 1 },
  "position",
  { data_type => "integer", is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "mime",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "uploaded",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "path",
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


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-03-02 18:22:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8ysAi/uD3w9IHY0PIKGutg

__PACKAGE__->load_components(qw/Ordered InflateColumn::FS PK::Auto Core/);

__PACKAGE__->add_columns(
	"path",
	{
		data_type      => 'text',
		is_fs_column   => 1,
		fs_column_path => Site::Portfolio->path_to('etc', 'media')."", #__PACKAGE__->config->{store_path}
	}
);

__PACKAGE__->belongs_to(
	gid => 'Site::Portfolio::Schema::PortfolioDb::Result::Gallery'
);

__PACKAGE__->position_column('position');
__PACKAGE__->grouping_column('gid');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
