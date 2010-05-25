package LocalHatena::Server::Keyword;
use strict;
use warnings;

use Path::Class;

use base qw/LocalHatena::Server/;

sub new {
    my ($class, $req) = @_;
    my ($group, $name) = ($req->param('group'), $req->param('name'));
    bless { group => $group, name => $name }, $class;
}

sub do_serve {
    my $self = shift;
    my $keywords = $self->hatena->keywords;
    if ($self->{group}) {
        warn 'group';
        my $tmp = $keywords->{$self->{group}};
        $keywords = undef;
        $keywords->{$self->{group}} = $tmp;
        if ($self->{name}) {
            $keywords->{$self->{group}} = [grep { $_ eq $self->{name} } @{$keywords->{$self->{group}}}];
        }
    }

    my $stash;
    for my $group (reverse sort keys %$keywords) {
        for my $keyword (reverse sort @{$keywords->{$group}}) {
            my $body = file($self->hatena->keyword_root, $group, $keyword . '.txt')->slurp;
            $body = $self->hatena->format($body);
            push @{$stash->{$group}}, { name => $keyword, body => $body };
        }
    }

    my $html = $self->hatena->html('keywords', { keywords => $stash });
    [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ $html ] ];
}

1;
