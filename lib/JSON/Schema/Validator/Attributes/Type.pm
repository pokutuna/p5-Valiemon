package JSON::Schema::Validator::Attributes::Type;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use List::MoreUtils qw(any);

sub attr_name { 'type' }

sub validate {
    my ($class, $validator, $schema, $data) = @_;
    my $types = $schema->{type};

    my $is_valid = do {
        if (ref $types eq 'ARRAY') {
            any { $class->_check($validator, $_, $data) } @$types
        } else {
            $class->_check($validator, $types, $data);
        }
    };
    return $is_valid ? 1 : 0;
}

sub _check {
    my ($class, $validator, $type, $data) = @_;
    my $method = 'is_' . $type;
    $validator->prims->can($method) && $validator->prims->$method($data) ? 1 : 0;
}

1;
