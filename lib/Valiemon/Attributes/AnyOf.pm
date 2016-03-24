package Valiemon::Attributes::AnyOf;
use strict;
use warnings;
use utf8;
use parent qw(Valiemon::Attributes);

use Carp qw(croak);
use List::MoreUtils qw(any);

use Valiemon::Context;

sub attr_name { 'anyOf' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;

    my $anyOf = $schema->{anyOf};
    if (ref $anyOf ne 'ARRAY' || scalar @$anyOf < 1) {
        croak sprintf '`anyOf` must be an array and have at least one element at %s', $context->position
    }

    my $idx = 0;
    my $errors = [];
    # Clone context to avoid influencing sub_validator's error to main context.
    my $is_valid = any {
        my $clone_context = Valiemon::Context->clone_from($context);
        my ($is_partially_valid) = $clone_context->in_attr($class, sub {
            my $sub_v = $clone_context->sub_validator($_);
            my $is_valid = $clone_context->in(
                $idx++, sub { $sub_v->validate($data, $clone_context); }
            );
            # If error, keep the last error of clone_context so that
            # main context has (one of) validation error(s).
            unless ($is_valid) {
                push @$errors, $clone_context->errors->[-1]
            }
            $is_valid;
        });
        $is_partially_valid;
    } @$anyOf;

    unless ($is_valid) {
        return (0, $errors->[0]); # XXX should we keep all of errors?
    }
    return $is_valid;
}

1;
