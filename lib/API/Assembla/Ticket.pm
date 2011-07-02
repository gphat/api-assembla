package API::Assembla::Ticket;
use Moose;

# ABSTRACT: A Ticket in Assembla.

=head1 SYNOPSIS

=head1 DESCRIPTION

Assembla XXX

=cut

=attr created_on

The DateTime representing the time at which this ticket was created.

=cut

has 'created_on' => (
    is => 'rw',
    isa => 'DateTime'
);

=attr description

The ticket's description

=cut

has 'description' => (
    is => 'rw',
    isa => 'Str'
);

=attr id

The ticket's id.

=cut

has 'id' => (
    is => 'rw',
    isa => 'Str'
);

=attr name

The ticket's name.

=cut

has 'name' => (
    is => 'rw',
    isa => 'Str'
);

=attr number

The ticket's number.

=cut

has 'number' => (
    is => 'rw',
    isa => 'Int'
);

=attr priority

The ticket's priority.

=cut

has 'priority' => (
    is => 'rw',
    isa => 'Int'
);

=attr status_name

The ticket's status_name.

=cut

has 'status_name' => (
    is => 'rw',
    isa => 'Str'
);

=attr summary

The ticket's summary.

=cut

has 'summary' => (
    is => 'rw',
    isa => 'Str'
);

__PACKAGE__->meta->make_immutable;

1;

__END__
