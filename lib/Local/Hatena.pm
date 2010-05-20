package Local::Hatena;
use strict;
use warnings;

our $VERSION = "0.1";

use DirHandle;

sub new {
    my ($class, %opts) = @_;
    bless { %opts }, $class;
}

sub id { shift->{id}; }

sub droot {
}

sub groot {
    my $self = shift;
    my $root = sprintf "%s/.hatena/%s/group",$ENV{HOME}, $self->id;
}

sub groups {
    my $self = shift;
    $self->{groots} ||= do {
        my $dh = DirHandle->new($self->groot);
        my $groups;
        while (defined(my $r = $dh->read)) {
            push @$groups, $r if $r =~ /^[^.]\w+/;
        }
        return $groups;
    };
}

sub hatena_root {
    my $self = shift;
    sprintf "%s/.hatena/%s",$ENV{HOME}, $self->id;
}

sub rootdir {
    my ($self, $name) = @_;
    if ($name eq 'diary') {
        return join '/', $self->hatena_root, 'diary';
    } else {
        return join '/', $self->hatena_root, 'group', $name;
    }
}

sub entries {
    my $self = shift;
    $self->{entries} and return $self->{entries};
    my $entries;
    for my $name ('diary', @{$self->groups}) {
        my $dh = DirHandle->new($self->rootdir($name));
        while (defined(my $e = $dh->read)) {
            next unless $e =~ /(\d{4}-\d{2}-\d{2})\.txt/;
            push @{$entries->{$1}}, $name;
        }
    }
    $self->{entries} = $entries;
}

sub serve_index {
    my $self = shift;
    my $html = "<html><body><ul>";
    for my $date (reverse sort keys %{$self->entries}) {
        my ($y, $m, $d) = $date =~ /(\d{4})-(\d{2})-(\d{2})/;
        $html .= sprintf q!<li><a href="/%s/%s/%s">%s/%s/%s@%s</a></li>!, $y, $m, $d, $y, $m, $d, join(',', @{$self->entries->{$date}});
    }
    $html .= "</ul></body></html>";
    [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ $html ] ];
}

sub serve_entry {
    my ($self, $env) = @_;
    my $path = $env->{PATH_INFO};
    my $filepath = join '-', grep { $_ ne '' } split('/', $path); # XXX: treat neatly
#     $filepath = sprintf "%s/%s%s", $self->droot, $filepath, '.txt'; # XXX
#     -e $filepath or return [ 404, ['Content-Type' => 'text/html'], [ '404 Not Found' ] ];

    # XXX: for loop and join
    my $body = file($filepath)->slurp;
#     $body = Text::Xatena->new->format($body,
#        inline => Text::Xatena::Inline::Aggressive->new(cache => Cache::FileCache->new({default_expires_in => 60 * 60 * 24 * 30})));

    $body = file("static/html/header.html")->slurp . $body;
    $body .= file("static/html/footer.html")->slurp;

    [200,  ['Content-Type' => 'text/html; charset=utf-8'], [$body]];
}

1;
__END__
{ 20100101 => ['diary', 'group1', 'group2'],
    ...
}
