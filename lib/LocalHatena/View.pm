package LocalHatena::View;
use strict;
use warnings;

use Path::Class;
use Text::MicroTemplate::File;
use Exporter::Lite;
our @EXPORT = qw/html/;

sub html {
    my ($hatena, $file, @args) = @_;
    $hatena->{mt} ||= Text::MicroTemplate::File->new(
        include_path => [ 'templates' ],
        use_cache => 0,
        tag_start => '<%',
        tag_end   => '%>',
        line_start => '%',
        escape_func => undef,
    );
    #warn @args;
    $hatena->{mt}->render_file($file, @args);
}

1;
