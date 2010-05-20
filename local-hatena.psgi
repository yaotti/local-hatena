use strict;
use warnings;
use Plack;
use Path::Class;
use Text::Xatena;

my $id = "yaotti";
my $droot = sprintf "%s/.hatena/%s/diary",$ENV{HOME}, $id;

my $app = sub {
    my $env = shift;
    my $path = $env->{PATH_INFO};
    if ($path eq '/favicon.ico') {
        return [ 200, ['Content-Type' => 'image/x-icon'], [] ];
    } elsif ($path eq '/') {
        return [ 200, ['Content-Type' => 'text/html; charset=utf-8'], ['Hello Index']];
    }
    my $filepath = join '-', grep { $_ ne '' } split('/', $path);
    $filepath = sprintf "%s/%s%s", $droot, $filepath, '.txt';
    -e $filepath or return [ 404, ['Content-Type' => 'text/html'], [ '404 Not Found' ] ];
    my $body = file($filepath)->slurp;
    $body = Text::Xatena->new->format($body);
    [200,  ['Content-Type' => 'text/html; charset=utf-8'], [$body]];
};
