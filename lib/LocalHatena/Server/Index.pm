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
    my $html = $self->hatena->html('index', {entries => $self->hatena->entries, keywords => $self->hatena->keywords });
    [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ $html ] ];
}

1;
