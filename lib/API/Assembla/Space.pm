package API::Assembla::Space;
use Moose;

# ABSTRACT: Profile based data verification with Moose type constraints.

=head1 SYNOPSIS

=attr created_at

The DateTime representing the time at which this space was created.

=cut

has 'created_at' => (
    is => 'rw',
    isa => 'DateTime'
);

=attr description

The space's description

=cut

has 'description' => (
    is => 'rw',
    isa => 'Str'
);

=attr id

The space's id.

=cut

has 'id' => (
    is => 'rw',
    isa => 'Str'
);

=attr name

The space's name.

=cut

has 'name' => (
    is => 'rw',
    isa => 'Str'
);

=head1 DESCRIPTION

Assembla XXX

=cut

__PACKAGE__->meta->make_immutable;

1;

__END__
