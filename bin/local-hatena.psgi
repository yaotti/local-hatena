#!/usr/bin/env perl
use strict;
use warnings;
use Plack;

use lib "lib";
use LocalHatena::Server;

my $app = sub {
    my $env = shift;
    LocalHatena::Server->new(id => ($ENV{HATENA_ID} || 'yaotti'))->run($env);
};

# my $app = sub {
#     my $env = shift;
#     my $path = $env->{PATH_INFO};

#     my $server = LocalHatena::Server->new(id => $ENV{HATENA_ID} || 'yaotti');

#     if ($path eq '/favicon.ico') {
#         return [ 200, ['Content-Type' => 'image/x-icon'], [] ];
#     } elsif ($path eq '/') {
#         return $server->serve_index;
#     } elsif ($path =~ m!/search?q=(.*)!) {
#         #return $lhtn->serve_search($1);
#     } elsif ($path =~ m!/keyword/(.*)!) {
#         #return $lhtn->serve_search($1);
#     } else {
#         return $lhtn->serve_entry($path);
#     }
# };
