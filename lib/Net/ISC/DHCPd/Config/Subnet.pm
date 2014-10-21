package Net::ISC::DHCPd::Config::Subnet;

=head1 NAME

Net::ISC::DHCPd::Config::Subnet - Subnet config parameter

=head1 DESCRIPTION

See L<Net::ISC::DHCPd::Config::Role> for methods and attributes without
documentation.

An instance from this class, comes from / will produce:

    subnet $address_attribute_value \
        netmask $address_attribute_value {
        $options_attribute_value
        $filename_attribute_value
        $range_attribute_value
        $pool_attribute_value
        $hosts_attribute_value
    }

=head1 SYNOPSIS

See L<Net::ISC::DHCPd::Config/SYNOPSIS>.

=cut

use Moose;
use NetAddr::IP;

with 'Net::ISC::DHCPd::Config::Role';

__PACKAGE__->create_children(qw/
    Net::ISC::DHCPd::Config::Host
    Net::ISC::DHCPd::Config::Pool
    Net::ISC::DHCPd::Config::Range
    Net::ISC::DHCPd::Config::Filename
    Net::ISC::DHCPd::Config::Option
/);

=head1 ATTRIBUTES

=head2 options

A list of parsed L<Net::ISC::DHCPd::Config::Option> objects.

=head2 ranges

A list of parsed L<Net::ISC::DHCPd::Config::Range> objects.

=head2 hosts

A list of parsed L<Net::ISC::DHCPd::Config::Host> objects.

=head2 filenames

A list of parsed L<Net::ISC::DHCPd::Config::Filename> objects. There can
be only be one node in this list.

=cut

before add_filename => sub {
    if(0 < int @{ $_[0]->filenames }) {
        confess 'Subnet cannot have more than one filename';
    }
};

=head2 pools

A list of parsed L<Net::ISC::DHCPd::Config::Pool> objects.

=head2 address

This attribute holds an instance of L<NetAddr::IP>, and represents
the ip address of this subnet.

=cut

has address => (
    is => 'ro',
    isa => 'NetAddr::IP',
);

=head2 regex

See L<Net::ISC::DHCPd::Config/regex>.

=cut

sub _build_regex { qr{^ \s* subnet \s (\S+) \s netmask \s (\S+) }x }

=head1 METHODS

=head2 captured_to_args

See L<Net::ISC::DHCPd::Config::Role/captured_to_args>.

=cut

sub captured_to_args {
    return { address => NetAddr::IP->new(join "/", @_[1,2]) };
}

=head2 generate

See L<Net::ISC::DHCPd::Config::Role/generate>.

=cut

sub generate {
    my $self = shift;
    my $net = $self->address;

    return(
        'subnet ' .$net->addr .' netmask ' .$net->mask .' {',
        $self->generate_config_from_children,
        '}',
    );
}

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<Net::ISC::DHCPd>.

=cut

1;
