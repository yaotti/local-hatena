#!/usr/bin/env perl
use strict;
use warnings;
use Plack;
use Path::Class;
use Text::Xatena;
use Text::Xatena::Inline::Aggressive;
use Cache::FileCache;

use lib "lib";
use Local::Hatena::Server;

my $app = sub {
    my $env = shift;
    my $path = $env->{PATH_INFO};

    my $server = Local::Hatena::Server->new(id => $ENV{HATENA_ID} || "yaotti");

    if ($path eq '/favicon.ico') {
        return [ 200, ['Content-Type' => 'image/x-icon'], [] ];
    } elsif ($path eq '/') {
        return $server->serve_index;
    }

    my $filepath = join '-', grep { $_ ne '' } split('/', $path);
    $filepath = sprintf "%s/%s%s", $server->droot, $filepath, '.txt'; # XXX
    -e $filepath or return [ 404, ['Content-Type' => 'text/html'], [ '404 Not Found' ] ];

    my $body = file($filepath)->slurp;
    $body = Text::Xatena->new->format($body,
       inline => Text::Xatena::Inline::Aggressive->new(cache => Cache::FileCache->new({default_expires_in => 60 * 60 * 24 * 30})));

    $filepath = "static/html/header.html";
    $body = file($filepath)->slurp . $body if -e $filepath;
    $filepath = "static/html/footer.html";
    $body .= file($filepath)->slurp if -e $filepath;

    [200,  ['Content-Type' => 'text/html; charset=utf-8'], [$body]];
};
