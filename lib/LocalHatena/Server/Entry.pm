package LocalHatena::Server::Entry;
use strict;
use warnings;

use Path::Class;

use base qw/LocalHatena::Server/;

sub new {
    my ($class, $req) = @_;
    my ($y, $m, $d) = grep { $_ ne '' }
      split '/', substr($req->path_info, 1);
    bless { year => $y, month => $m, day => $d }, $class;
}

sub do_serve {
    my $self = shift;
    my ($y, $m, $d) = ($self->{year}, $self->{month}, $self->{day});

    return [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ 'TOO MANY ENTRIES' ] ] unless $m; # /YYYY

    my $entries = $self->hatena->entries;
    my $dates;
    if (!$self->{day}) {  # /YYYY/MM
        push @$dates, join('-', $y, $m, $_) for reverse sort keys %{$entries->{$y}->{$m}};
    } else {                    # /YYYY/MM/DD
        $dates = [join '-', ($y, $m, $d)];
    }

    my $stash;
    for my $date (@$dates) {    # dates
        my ($y, $m, $d) = split '-', $date;
        my $names = $entries->{$y}->{$m}->{$d};
        for my $name (@$names) { # groups
            push @$stash, $self->formatted_body_on_date($name, $date);
        }
    }
    my $html = $self->hatena->html('entry', {entries => $stash});
    [200,  ['Content-Type' => 'text/html; charset=utf-8'], [$html]];
}

sub formatted_body_on_date {
    my ($self, $name, $date) = @_;
    my $body = file($self->hatena->rootdir($name), $date)->slurp;
    $body = Text::Xatena->new->format($body,
                                      inline => Text::Xatena::Inline::Aggressive->new(cache =>
                                                                                      Cache::FileCache->new({default_expires_in => 60 * 60 * 24 * 30})));
    { name => $name, body => $body };
}

1;
