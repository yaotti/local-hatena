package Local::Hatena;
use strict;
use warnings;

our $VERSION = "0.1";

use DirHandle;

sub new {
    my ($class, %opts) = @_;
    bless { %opts }, $class;
}

sub dirs {
    my $self = shift;
    #$self->{dirs} ||= [ $self->droot, @{$self->groots} ];
    $self->{dirs} ||= [ $self->droot ];
}

sub id { shift->{id}; }

sub droot {
    my $self = shift;
    ['DIARY', sprintf "%s/.hatena/%s/diary",$ENV{HOME}, $self->id];
}

sub groots {                    # XXX
    my $self = shift;
    [[]];
}

sub serve_index {
    my $self = shift;
    my $files;
    my $dirs = $self->dirs;

    for my $dir (@$dirs) {
        my $dh = DirHandle->new($dir->[1]);
        while (defined(my $e = $dh->read)) {
            push @$files, [$dir->[0], $e] if $e =~ /\d{4}-\d{2}-\d{2}\.txt/;
        }
    }

    # sort entries
    my $html = "<html><body><ul>";
    for my $file (sort { $a->[1] cmp $b->[1] } @$files) {
        my ($y, $m, $d) = $file->[1] =~ /(\d{4})-(\d{2})-(\d{2})\.txt/;
        $html .= sprintf q!<li><a href="/%s/%s/%s">%s/%s/%s@%s</a></li>!, $y, $m, $d, $y, $m, $d, $file->[0];
    }
    $html .= "</ul></body></html>";
    [ 200, ['Content-Type' => 'text/html; charset=utf-8'], [ $html ] ];
}

1;
__END__

group dir: [$groupname, $path]
diary dir: ['diary', $path]
