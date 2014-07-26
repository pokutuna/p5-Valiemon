package JSON::Schema::Validator::Attributes::Type;
use strict;
use warnings;
use utf8;

use List::MoreUtils qw(any);
use JSON::Schema::Validator::Primitives qw(prim);
use JSON::Schema::Validator::ValidationError;

sub attr_name { 'type' }

sub validate {
    my ($class, $schema, $data, $errors) = @_;
    my $types = $schema->{type};

    # `type` must be array or string
    my $valid = undef;
    if (ref $types eq 'ARRAY') {
        $valid = any { $class->_check($_, $data) } @$types
    } else {
        $valid = $class->_check($types, $data);
    }

    unless ($valid) {
        push @$errors, JSON::Schema::Validator::ValidationError->new(
            $schema, $data, $class->attr_name
        );
    }

    return $valid ? 1 : 0;
}

sub _check {
    my ($class, $type, $data) = @_;
    my $method = 'is_' . $type;
    prim->can($method) && prim->$method($data) ? 1 : 0;
}

1;
