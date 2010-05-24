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
    my $html = "<html><body>";
    my $entries = $self->hatena->entries;
    for my $y (reverse sort keys %$entries) {
        $html .= sprintf q!<h2>%s</h2>!, $y;
        $html .= "<ul>";
        for my $m (reverse sort keys %{$entries->{$y}}) {
            $html .= sprintf q!<li><a href="/%s/%s">%s</a></li>!, $y, $m, $m;
            $html .= "<ul>";
            for my $d (reverse sort keys %{$entries->{$y}->{$m}}) {
                $html .= sprintf q!<li><a href="/%s/%s/%s">%s@%s</a></li>!, $d, $y, $m, $d, join(',', @{$entries->{$y}->{$m}->{$d}});
            }
            $html .= "</ul>";
        }
        $html .= "</ul>";
    }
    $html .= "</ul></body></html>";
    [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ $html ] ];
}

1;
