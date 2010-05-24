package LocalHatena::Server::Entry;
use strict;
use warnings;

use Path::Class;
use Text::Xatena;
use Text::Xatena::Inline::Aggressive;
use Cache::FileCache;

use base qw/LocalHatena::Server/;


sub new {
    my ($class, $env) = @_;
    my ($y, $m, $d) = grep { $_ ne '' }
      split '/', substr($env->{PATH_INFO}, 1);
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

    my $html;
    for my $date (@$dates) {    # dates
        my ($y, $m, $d) = split '-', $date;
        my $names = $entries->{$y}->{$m}->{$d};
        for my $name (@$names) { # groups
            my $filepath = sprintf "%s/%s.txt", $self->hatena->rootdir($name), $date;
            my $body = file($filepath)->slurp;
            $html .= sprintf "<h2 class='entry-type'>%s</h2>", $name;
            $html .= Text::Xatena->new->format($body,
                                               inline => Text::Xatena::Inline::Aggressive->new(cache => Cache::FileCache->new({default_expires_in => 60 * 60 * 24 * 30})));
        }
    }
    $html = file("static/html/header.html")->slurp . $html;
    $html .= file("static/html/footer.html")->slurp;
    [200,  ['Content-Type' => 'text/html; charset=utf-8'], [$html]];
}

1;
