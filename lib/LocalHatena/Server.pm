package LocalHatena::Server;
use strict;
use warnings;
use Plack::Request;
use LocalHatena;
use UNIVERSAL::require;


sub new {
    my ($class, %opts) = @_;
    my $lh = LocalHatena->new(id => delete $opts{id});
    bless { %opts, hatena => $lh }, $class;
}

sub hatena {
    shift->{hatena};
}

sub run {
    my ($self, $env) = @_;
    my $req = Plack::Request->new($env);
    my $path = $req->path_info;
    if ($path eq '/favicon.ico') {
        return [ 200, ['Content-Type' => 'image/x-icon'], [] ];
    }
    my ($module) = $path =~ m!/([^/]+)!;
    if (not $module) {
        $module = 'Index';
    } elsif ($module =~ /\d+/) {
        $module = 'Entry';
    }
    $module = join('::', __PACKAGE__, ucfirst($module));

    $module->require or return [ 404, ['Content-Type' => 'text/html'], ['not found']];

    my $server = $module->new($req);
    $server->{hatena} = $self->hatena; # ???
    return $server->do_serve;
}

sub do_serve {
    die;
}

1;
