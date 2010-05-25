#!/usr/bin/env perl
use strict;
use warnings;

use Plack::Builder;
use Path::Class;
use File::Basename qw(dirname);

use lib "lib";
use LocalHatena::Server;

my $app = sub {
    my $env = shift;
    LocalHatena::Server->new(id => ($ENV{HATENA_ID} || 'yaotti'))->run($env);
};

builder {
    enable "Plack::Middleware::Static",
      path => qr!^/static/!, root => dirname(__FILE__) . '/../';
    $app;
};
