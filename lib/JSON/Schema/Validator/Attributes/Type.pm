package JSON::Schema::Validator::Attributes::Type;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use List::MoreUtils qw(any);
use JSON::Schema::Validator::Primitives qw(prim);

sub attr_name { 'type' }

sub validate {
    my ($class, $validator, $schema, $data) = @_;
    my $types = $schema->{type};

    my $is_valid = do {
        if (ref $types eq 'ARRAY') {
            any { $class->_check($_, $data) } @$types
        } else {
            $class->_check($types, $data);
        }
    };
    return $is_valid ? 1 : 0;
}

sub _check {
    my ($class, $type, $data) = @_;
    my $method = 'is_' . $type;
    prim->can($method) && prim->$method($data) ? 1 : 0;
}

1;
