package API::Assembla;
use Moose;

use DateTime::Format::ISO8601;
use LWP::UserAgent;
use URI;
use XML::XPath;

use API::Assembla::Space;

# ABSTRACT: Acess to Assembla API via Perl.

=head1 SYNOPSIS

    use API::Assembla;

    my $api = API::Asembla->new(
        account_name => $accountname',
        username => $username,
        password => $password
    );

    my $href = $api->get_space;


=head1 DESCRIPTION

Assembla XXX

=cut

has '_client' => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    lazy => 1,
    default => sub {
        my $self = shift;
        return LWP::UserAgent->new;
    }
);

=attr password

The password to use when logging in.

=cut

has 'password' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

=attr url

The URL to use when working with the api.  Defaults to

  http://www.assembla.com
  
=cut

has 'url' => (
    is => 'ro',
    isa => 'URI',
    lazy => 1,
    default => sub {
        my $self = shift;
        return URI->new('https://www.assembla.com/');
    }
);

=attr username

The username to use when logging in.

=cut

has 'username' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

=method get_spaces

Get Space information.  Returns a hashref with the following keys

=over 4

=item third-level-domain

=item name

=item plan-id

=item time-zone

=item owner-id

=item suspended

=item id

=item updated-at

=back

=cut

sub get_spaces {
    my ($self) = @_;

    my $req = $self->make_req('/spaces/my_spaces');
    my $resp = $self->_client->request($req);

    print STDERR $resp->decoded_content;

    my $xp = XML::XPath->new(xml => $resp->decoded_content);

    my $spaces = $xp->find('/spaces/space');

    my %objects = ();
    foreach my $space ($spaces->get_nodelist) {

        my $name = $space->findvalue('name')."";

        $objects{$name} = API::Assembla::Space->new(
            id => $space->findvalue('id').'',
            created_at => DateTime::Format::ISO8601->parse_datetime($space->findvalue('created-at').''),
            name => $name,
            description => $space->findvalue('description').'',
        );
    }

    return \%objects;
}

sub make_req {
    my ($self, $path) = @_;

    my $req = HTTP::Request->new(GET => $self->url.$path);
    $req->header(Accept => 'application/xml');
    $req->authorization_basic($self->username, $self->password);
    return $req;
}

__PACKAGE__->meta->make_immutable;

1;

__END__


=begin :postlude

=head1 CONTRIBUTORS

Me

=end :postlude

