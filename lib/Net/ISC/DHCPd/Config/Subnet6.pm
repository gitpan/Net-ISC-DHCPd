package Net::ISC::DHCPd::Config::Subnet6;

=head1 NAME

Net::ISC::DHCPd::Config::Subnet6 - Subnet6 config parameter

=head1 DESCRIPTION

See L<Net::ISC::DHCPd::Config::Role> for methods and attributes without
documentation.

An instance from this class, comes from / will produce:

    subnet6 $address_attribute_value {
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
use NetAddr::IP qw(:lower);

with 'Net::ISC::DHCPd::Config::Role';

=head2 children

See L<Net::ISC::DHCPd::Config::Role/children>.

=cut
sub children {
    return qw/
        Net::ISC::DHCPd::Config::Host
        Net::ISC::DHCPd::Config::Pool
        Net::ISC::DHCPd::Config::Range6
        Net::ISC::DHCPd::Config::Filename
        Net::ISC::DHCPd::Config::Option
        Net::ISC::DHCPd::Config::KeyValue
        Net::ISC::DHCPd::Config::Block
        /;
}

__PACKAGE__->create_children(__PACKAGE__->children());

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
        confess 'Subnet6 cannot have more than one filename';
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

sub regex { qr{^ \s* subnet6 \s+ (\S+) }x }

=head1 METHODS

=head2 captured_to_args

See L<Net::ISC::DHCPd::Config::Role/captured_to_args>.

=cut

sub captured_to_args {
    return { address => NetAddr::IP->new($_[0]) };
}

=head2 generate

See L<Net::ISC::DHCPd::Config::Role/generate>.

=cut

sub generate {
    my $self = shift;
    my $net = $self->address;

    return(
        'subnet6 ' .$net->short() .'/' . $net->masklen() . ' {',
        $self->_generate_config_from_children,
        '}',
    );
}

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<Net::ISC::DHCPd>.

=cut
__PACKAGE__->meta->make_immutable;
1;
