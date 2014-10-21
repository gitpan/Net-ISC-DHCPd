package Net::ISC::DHCPd::Config::OptionSpace::Option;

=head1 NAME

Net::ISC::DHCPd::Config::OptionSpace::Option - Optionspace config param data

=head1 DESCRIPTION

See L<Net::ISC::DHCPd::Config::Role> for methods and attributes without
documentation.

=head1 SYNOPSIS

See L<Net::ISC::DHCPd::Config> for synopsis.

=cut

use Moose;

with 'Net::ISC::DHCPd::Config::Role';

=head1 OBJECT ATTRIBUTES

=head2 name

 $string = $self->name;

Human readable name of this option, without parent name prefix

=cut

has name => (
    is => 'ro',
    isa => 'Str',
);

=head2 code

 $int = $self->name;

Computer readable code for this option.

=cut

has code => (
    is => 'ro',
    isa => 'Int',
);

=head2 value

 $string = $self->value;

Value of the option.

=cut

has value => (
    is => 'ro',
    isa => 'Str',
);

=head2 quoted

 $bool = $self->quoted;

This flag tells if the option value should be quoted or not.

=cut

has quoted => (
    is => 'ro',
    isa => 'Bool',
);

=head2 regex

=cut

has '+regex' => (
    lazy => 1,
    default => sub {
        qr{^\s* option \s (\S+)\.(\S+) \s code \s (\d+) \s = \s (.*) ;}x;
    },
);

=head1 METHODS

=head2 captured_to_args

=cut

sub captured_to_args {
    my $self   = shift;
    my $prefix = shift;
    my $name   = shift;
    my $code   = shift;
    my $value  = shift;
    my $quoted = 0;

    $quoted = 1 if($value =~ s/^"(.*)"$/$1/g);

    return {
        name   => $name,
        code   => $code,
        value  => $value,
        quoted => $quoted,
    };
}

=head2 generate

=cut

sub generate {
    my $self = shift;

    sprintf("option %s.%s code %i = %s;",
        $self->parent->prefix,
        $self->name,
        $self->code,
        $self->value,
    );
}

=head1 AUTHOR

See L<Net::ISC::DHCPd>.

=cut

1;
