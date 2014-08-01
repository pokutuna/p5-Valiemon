package JSON::Schema::Validator::Attributes::Required;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use Carp qw(croak);
use List::MoreUtils qw(all);

sub attr_name { 'required' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;

    return 1 unless ref $data eq 'HASH'; # ignore

    my $required = $schema->{required};
    $context->in_attr($class, sub {
        if (ref $required ne 'ARRAY' || scalar @$required < 1) {
            croak sprintf '`required` must be an array and have at leas one element at %s', $context->position
        }
        all {
            my $has_default = do {
                my $prop_def = $schema->{properties};
                $prop_def && $prop_def->{$_} && $prop_def->{$_}->{default};
            };
            $has_default || exists $data->{$_}
        } @$required;
    });
}

1;
