package Variemon::Attributes::Required;
use strict;
use warnings;
use utf8;
use parent qw(Variemon::Attributes);

use Carp qw(croak);
use List::MoreUtils qw(all);

sub attr_name { 'required' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;

    return 1 unless ref $data eq 'HASH'; # ignore

    my $required = $schema->prop('required');
    $context->in_attr($class, sub {
        if (ref $required ne 'ARRAY' || scalar @$required < 1) {
            croak sprintf '`required` must be an array and have at leas one element at %s', $context->position
        }
        all {
            my $prop_def = $schema->get('properties')->get($_);
            my $has_default = !$prop_def->is_undef && $schema->new_sub_schema($prop_def)->get_default;
            $has_default || exists $data->{$_};
        } @$required;
    });
}

1;
