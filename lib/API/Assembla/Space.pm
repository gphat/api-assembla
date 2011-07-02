package API::Assembla::Space;
use Moose;

# ABSTRACT: Profile based data verification with Moose type constraints.

=head1 SYNOPSIS

=attr description

The space's description

=cut

has 'description' => (
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
