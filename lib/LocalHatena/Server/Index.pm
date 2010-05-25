package LocalHatena::Server::Index;
use strict;
use warnings;

use base qw/LocalHatena::Server/;

sub new {
    my $class = shift;
    bless {}, $class;
}

sub do_serve {
    my $self = shift;
    my $entries = $self->hatena->entries;
    my $html = $self->hatena->html('index', {entries => $entries});
    [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ $html ] ];
}

1;






