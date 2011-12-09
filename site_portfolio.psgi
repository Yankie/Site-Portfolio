use strict;
use warnings;

use Site::Portfolio;

my $app = Site::Portfolio->apply_default_middlewares(Site::Portfolio->psgi_app);
$app;

