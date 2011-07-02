package API::Assembla;
use Moose;

use DateTime::Format::ISO8601;
use LWP::UserAgent;
use URI;
use XML::XPath;

use API::Assembla::Space;
use API::Assembla::Ticket;

# ABSTRACT: Access to Assembla API via Perl.

=head1 SYNOPSIS

    use API::Assembla;

    my $api = API::Asembla->new(
        account_name => $accountname',
        username => $username,
        password => $password
    );

    my $href_of_spaces = $api->get_spaces;
    # Got an href of API::Assembla::Space objects keyed by space id
    my $space = $api->get_space($space_id);
    # Got an API::Assembla::Space object

    my $href_of_tickets = $api->get_tickets;
    # Got an href of API::Assembla::Space objects keyed by ticket id
    my $ticket = $api->get_ticket($space_id, $ticket_number);
    # Got an API::Assembla::Ticket object

=head1 DESCRIPTION

API::Assembla is a Perl interface to L<Assembla|http://www.assembla.com/>, a
ticketing, code hosting collaboration tool.

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

=method get_space ($id)

Get Space information.

=cut

sub get_space {
    my ($self, $id) = @_;

    my $req = $self->make_req('/spaces/'.$id);
    my $resp = $self->_client->request($req);

    # print STDERR $resp->decoded_content;

    my $xp = XML::XPath->new(xml => $resp->decoded_content);

    my $space = $xp->find('/space')->pop;
    my $name = $space->findvalue('name')."";

    return API::Assembla::Space->new(
        id => $space->findvalue('id').'',
        created_at => DateTime::Format::ISO8601->parse_datetime($space->findvalue('created-at').''),
        name => $name,
        description => $space->findvalue('description').'',
    );
}

=method get_spaces

Get Space information.  Returns a hashref of L<API::Assembla::Space> objects
keyed by the space's name.

=cut

sub get_spaces {
    my ($self) = @_;

    my $req = $self->make_req('/spaces/my_spaces');
    my $resp = $self->_client->request($req);

    # print STDERR $resp->decoded_content;

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

=method get_tickets ($space_id, $number)

Get Tickets for a space information.

=cut

sub get_ticket {
    my ($self, $id, $number) = @_;

    my $req = $self->make_req('/spaces/'.$id.'/tickets/'.$number);
    my $resp = $self->_client->request($req);

    # print STDERR $resp->decoded_content;

    my $xp = XML::XPath->new(xml => $resp->decoded_content);

    my $ticket = $xp->find('/ticket')->pop;

    return API::Assembla::Ticket->new(
        id => $ticket->findvalue('id').'',
        created_on => DateTime::Format::ISO8601->parse_datetime($ticket->findvalue('created-on').''),
        description => $ticket->findvalue('description').'',
        number => $ticket->findvalue('number').'',
        priority => $ticket->findvalue('priority').'',
        status_name => $ticket->findvalue('status-name').'',
        summary => $ticket->findvalue('summary').''
    );
}


=method get_tickets ($space_id)

Get Tickets for a space information.

=cut

sub get_tickets {
    my ($self, $id) = @_;

    my $req = $self->make_req('/spaces/'.$id.'/tickets');
    my $resp = $self->_client->request($req);

    # print STDERR $resp->decoded_content;

    my $xp = XML::XPath->new(xml => $resp->decoded_content);

    my $tickets = $xp->find('/tickets/ticket');

    my %objects = ();
    foreach my $ticket ($tickets->get_nodelist) {

        my $id = $ticket->findvalue('id').'';

        $objects{$id} = API::Assembla::Ticket->new(
            id => $id,
            created_on => DateTime::Format::ISO8601->parse_datetime($ticket->findvalue('created-on').''),
            description => $ticket->findvalue('description').'',
            number => $ticket->findvalue('number').'',
            priority => $ticket->findvalue('priority').'',
            status_name => $ticket->findvalue('status-name').'',
            summary => $ticket->findvalue('summary').''
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

