use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Site::Portfolio';
use Site::Portfolio::Controller::Blog;

ok( request('/blog')->is_success, 'Request should succeed' );
done_testing();
