use strict;
use warnings;
use lib qw(/home/yankie/projects/own/site-portfolio/lib);
use Site::Portfolio;

my $app = Site::Portfolio->apply_default_middlewares(Site::Portfolio->psgi_app);
$app;

