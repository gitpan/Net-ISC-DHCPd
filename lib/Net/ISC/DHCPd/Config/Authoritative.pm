package Net::ISC::DHCPd::Config::Authoritative;

=head1 NAME

Net::ISC::DHCPd::Config::Authoritative - Yeah, it's a special parser for one statement

=head1 DESCRIPTION

See L<Net::ISC::DHCPd::Config::Role> for methods and attributes without
documentation.

An instance from this class, comes from / will produce one of the
lines below, dependent on L</quoted>.

    authoritative;

=head1 SYNOPSIS

See L<Net::ISC::DHCPd::Config/SYNOPSIS>.

=cut

use Moose;

with 'Net::ISC::DHCPd::Config::Role';

=head1 ATTRIBUTES

=head2 name

Name of the option - See L</DESCRIPTION> for details.

=cut

has space => (
    is => 'ro',
    isa => 'Str',
);

=head2 regex

See L<Net::ISC::DHCPd::Config::Role/regex>.

=cut
sub regex { qr{^\s* authoritative (\s*) ;}x }

=head1 METHODS

=head2 captured_to_args

See L<Net::ISC::DHCPd::Config::Role/captured_to_args>.

=cut

sub captured_to_args {
    my $space  = shift;

    return {
        space  => $space,
    };
}

=head2 generate

See L<Net::ISC::DHCPd::Config::Role/generate>.

=cut

sub generate {
    my $self  = shift;
    return sprintf qq(authoritative%s;), $self->space;
}

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<Net::ISC::DHCPd>.

=cut
__PACKAGE__->meta->make_immutable;
1;
