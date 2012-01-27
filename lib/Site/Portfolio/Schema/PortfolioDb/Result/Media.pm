package Site::Portfolio::Schema::PortfolioDb::Result::Media;

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

Site::Portfolio::Schema::PortfolioDb::Result::Media

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
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-10 18:07:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/izQVMS1krEGU70ja2BTHw


__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");

__PACKAGE__->add_columns(
	"path",
	{
		data_type      => 'text',
		is_fs_column   => 1,
		fs_column_path => Site::Portfolio->path_to( 'etc', 'media' ) . ""
	}
);

__PACKAGE__->belongs_to(
	gid => 'Site::Portfolio::Schema::PortfolioDb::Result::Gallery'
);


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
