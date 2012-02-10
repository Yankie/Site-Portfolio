#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Site-Portfolio';
all_from 'lib/Site/Portfolio.pm';

requires 'Catalyst::Runtime' => '5.90007';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode::Encoding';
requires 'DBIx::Class::Core';
requires 'DBIx::Class::InflateColumn::DateTime';
requires 'DBIx::Class::InflateColumn::FS';
requires 'DBIx::Class::PK';
requires 'DBIx::Class::PK::Auto';
requires 'DBIx::Class::Schema';
requires 'DateTime';
requires 'Imager';
requires 'Imager::File::JPEG';
requires 'MIME::Types';
requires 'Moose';
requires 'namespace::autoclean';

requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';


catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
