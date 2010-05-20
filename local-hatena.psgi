#!/usr/bin/env perl
use strict;
use warnings;
use Plack;
use Path::Class;
use Text::Xatena;
use Text::Xatena::Inline::Aggressive;
use Cache::FileCache;

use lib "lib";
use Local::Hatena;

my $app = sub {
    my $env = shift;
    my $path = $env->{PATH_INFO};

    my $lhtn = Local::Hatena->new(id => $ENV{HATENA_ID} || "yaotti");

    if ($path eq '/favicon.ico') {
        return [ 200, ['Content-Type' => 'image/x-icon'], [] ];
    } elsif ($path eq '/') {
        return $lhtn->serve_index;
    }#  elsif ($path =~ m!/search?q=(.*)!) {
#         return $lhtn->serve_search($path);
#     } elsif ($path =~ m!/keyword/(.*)!) {
#         return $lhtn->serve_search($1);
#     }
    else {
        return $lhtn->serve_entries($env);
    }
};








