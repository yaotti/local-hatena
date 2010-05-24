package LocalHatena;
use strict;
use warnings;

use DirHandle;

our $VERSION = "0.1";


sub new {
    my ($class, %opts) = @_;
    bless { %opts }, $class;
}

sub id { shift->{id}; }

sub groups {
    my $self = shift;
    $self->{groots} ||= do {
        my $groot = $self->hatena_root . "/group";
        my $dh = DirHandle->new($groot);
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
            next unless $e =~ /(\d{4})-(\d{2})-(\d{2})\.txt/;
            push @{$entries->{$1}->{$2}->{$3}}, $name;
        }
    }
    $self->{entries} = $entries;
}

1;
__END__
{ 2010 =>
    { 01 =>
      { 01 => ['diary', 'group1', 'group2'],
        ...
      },
      02 =>
      ...
    },
 2009 => ...
}
