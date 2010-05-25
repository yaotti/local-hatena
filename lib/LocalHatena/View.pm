package LocalHatena::View;
use strict;
use warnings;

use Path::Class;
use Text::MicroTemplate::Extended;
use Exporter::Lite;
our @EXPORT = qw/html/;

sub html {
    my ($hatena, $file, $args) = @_;
    my $mt = Text::MicroTemplate::Extended->new(
        include_path => [ 'templates' ],
        use_cache => 0,
        escape_func => undef,
        template_args => $args
    );
    #warn $args;
    $mt->render($file);
}

1;
