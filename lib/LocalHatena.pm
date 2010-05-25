package LocalHatena;
use strict;
use warnings;

use DirHandle;
use LocalHatena::View;
use Text::Xatena;
use Text::Xatena::Inline::Aggressive;
use Cache::FileCache;


our $VERSION = "0.1";


sub new {
    my ($class, %opts) = @_;
    bless { %opts }, $class;
}

sub id { shift->{id}; }

sub groups {
    my ($self, $type) = @_;
    $self->{groots} ||= do {
        my $groot = $type eq 'diary' ? $self->user_root . "/group" : $self->keyword_root;
        my $dh = DirHandle->new($groot);
        my $groups;
        while (defined(my $r = $dh->read)) {
            push @$groups, $r if $r =~ /^[^.]\w+/;
        }
        return $groups;
    };
}

sub hatena_root {
    $ENV{HOME}. '/.hatena';
}

sub user_root {
    my $self = shift;
    join '/', $self->hatena_root, $self->id;
}

sub keyword_root {
    my $self = shift;
    join '/', $self->hatena_root, 'keywords';
}

sub rootdir {
    my ($self, $name) = @_;
    if ($name eq 'diary') {
        return join '/', $self->user_root, 'diary';
    } else {
        return join '/', $self->user_root, 'group', $name;
    }
}

sub entries {
    my $self = shift;
    $self->{entries} and return $self->{entries};
    my $entries;
    for my $name ('diary', @{$self->groups('diary')}) {
        my $dh = DirHandle->new($self->rootdir($name));
        while (defined(my $e = $dh->read)) {
            next unless $e =~ /(\d{4})-(\d{2})-(\d{2})\.txt/;
            push @{$entries->{$1}->{$2}->{$3}}, $name;
        }
    }
    $self->{entries} = $entries;
}

sub keywords {
    my $self = shift;
    $self->{keywords} and return $self->{keywords};
    my $keywords;
    for my $name (@{$self->groups('keywords')}) {
        my $dh = DirHandle->new($self->keyword_root . "/" . $name);
        while (defined(my $e = $dh->read)) {
            next unless $e =~ /(.+)\.txt/;
            next if $1 eq 'cookie'; # ignore cookie file
            push @{$keywords->{$name}}, $1;
        }
    }
    $self->{keywords} = $keywords;
}

sub format {
    my ( $self, $body ) = @_;
    Text::Xatena->new->format(
        $body,
        inline => Text::Xatena::Inline::Aggressive->new(
            cache => Cache::FileCache->new(
                { default_expires_in => 60 * 60 * 24 * 30 }
            )
        )
    );
}

1;
__END__
Entry
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
Keyword
{ group1 =>
    [ 'keyword1', 'keyword2', ...],
  group2 => ...
}
