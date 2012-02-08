use strict;
use warnings;
use lib qw(/home/yankie/projects/own/site-portfolio/lib);
use Site::Portfolio;
use Plack::Handler::Apache2;

no warnings qw(redefine); 

# The method for PH::Apache2::Registry to override.
sub Plack::Handler::Apache2::fixup_path {
    my ($class, $r, $env) = @_;

    # $env->{PATH_INFO} is created from unparsed_uri so it is raw.
    my $path_info = $env->{PATH_INFO} || '';

    # Get argument of <Location> or <LocationMatch> directive
    # This may be string or regexp and we can't know either.
    my $location = $r->location;

    # Let's *guess* if we're in a LocationMatch directive
    if ($location eq '/') {
        # <Location /> could be handled as a 'root' case where we make
        # everything PATH_INFO and empty SCRIPT_NAME as in the PSGI spec
        $env->{SCRIPT_NAME} = '';
    } elsif ($path_info =~ s{^($location)/?}{/}) {
        $env->{SCRIPT_NAME} = $1 || '';
    } else {
        # Apache's <Location> is matched but here is not.
        # This is something wrong. We can only respect original.
        $r->server->log_error(
            "Your request path is '$path_info' and it doesn't match your Location(Match) '$location'. " .
            "This should be due to the configuration error. See perldoc Plack::Handler::Apache2 for details.",
        );
        $env->{SCRIPT_NAME} = '';
    }

    $env->{PATH_INFO}   = $path_info;
}

my $app = Site::Portfolio->apply_default_middlewares(Site::Portfolio->psgi_app);
$app;

