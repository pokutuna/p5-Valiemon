package JSON::Schema::Validator::Primitives;
use strict;
use warnings;
use utf8;

use Scalar::Util qw(looks_like_number);
use Types::Serialiser qw(is_bool);

sub new {
    my ($class, $options) = @_;
    return bless {
        options => $options,
    }, $class;
}

sub is_object {
    my ($self, $obj) = @_;
    ref $obj eq 'HASH' ? 1 : 0;
}

sub is_array {
    my ($self, $obj) = @_;
    ref $obj eq 'ARRAY' ? 1 : 0;
}

sub is_string {
    my ($self, $obj) = @_;
    (defined $obj && ref $obj eq '') ? 1 : 0; # really?
}

sub is_number {
    my ($self, $obj) = @_;
    looks_like_number($obj) ? 1 : 0;
}

sub is_integer {
    my ($self, $obj) = @_;
    $obj =~ qr/^-?\d+$/ ? 1 : 0; # TODO find more better way
}

sub is_bool {
    my ($self, $obj) = @_;
    return $self->{options}->{use_json_boolean}
        ? $self->is_boolean_json($obj)
        : $self->is_boolean_perl($obj)
}

sub is_boolean_perl {
    my ($self, $obj) = @_;
    ($obj == 1 || $obj == 0) ? 1 : 0; # TODO invalidate 0.0
}

sub is_boolean_json {
    my ($self, $obj) = @_;
    is_bool($obj) ? 1 : 0;
}

sub is_null {
    my ($self, $obj) = @_;
    !defined($obj) ? 1 : 0;
}

1;
