package Net::ISC::DHCPd::Config::Filename;

=head1 NAME

Net::ISC::DHCPd::Config::Filename - Filename config parameter

=head1 DESCRIPTION

See L<Net::ISC::DHCPd::Config::Role> for methods and attributes without
documentation.

An instance from this class, comes from / will produce:

    filename "$file_attribute_value";

=head1 SYNOPSIS

See L<Net::ISC::DHCPd::Config/SYNOPSIS>.

=cut

use Moose;
use Path::Class::File;
use MooseX::Types::Path::Class qw(File);

with 'Net::ISC::DHCPd::Config::Role';

=head1 ATTRIBUTES

=head2 file

This attribute hold a L<Path::Class::File> object.

=cut

has file => (
    is => 'rw',
    isa => File,
    coerce => 1,
);

sub _build_regex { qr{^\s* filename \s+ (\S+) ;}x }

=head1 METHODS

=head2 captured_to_args

See L<Net::ISC::DHCPd::Config::Role/captured_to_args>.

=cut

sub captured_to_args {
    return { file => Path::Class::File->new($_[1]) };
}

=head2 generate

See L<Net::ISC::DHCPd::Config::Role/generate>.

=cut

sub generate {
    return 'filename ' .shift->file .';';
}

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<Net::ISC::DHCPd>.

=cut

1;
