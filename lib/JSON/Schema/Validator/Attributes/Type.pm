package JSON::Schema::Validator::Attributes::Type;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use List::MoreUtils qw(any);

sub attr_name { 'type' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    $context->in_attr($class, sub {
        my $types = $schema->{type};

        my $is_valid = do {
            if (ref $types eq 'ARRAY') {
                any { $class->_check($context->rv, $_, $data) } @$types
            } else {
                $class->_check($context->rv, $types, $data);
            }
        };
        $is_valid;
    });
}

sub _check {
    my ($class, $validator, $type, $data) = @_;
    my $method = 'is_' . $type;
    $validator->prims->can($method) && $validator->prims->$method($data) ? 1 : 0;
}

1;
