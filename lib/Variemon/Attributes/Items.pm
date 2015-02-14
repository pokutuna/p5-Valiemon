package Variemon::Attributes::Items;
use strict;
use warnings;
use utf8;
use parent qw(Variemon::Attributes);

use Carp qw(croak);
use List::MoreUtils qw(all);
use Variemon;

sub attr_name { 'items' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    return 1 unless ref $data eq 'ARRAY'; # ignore

    my $items = $schema->sub_schema('items');
    if ($items->is_hash) {
        # schema
        return $context->in_attr($class, sub {
            my $idx = 0;
            my $sub_v = $context->sub_validator($items);
            all {
                $context->in($idx, sub { $sub_v->validate($_, $context) });
                $idx += 1;
            } @$data;
        });
    } elsif ($items->is_array) {
        # index base
        return $context->in_attr($class, sub {
            my $is_valid = 1;
            for (my $i = 0; $i < @{$items->raw}; $i++) {
                my $v = $context->in($i, sub {
                    $context->sub_validator($items->raw->[$i])
                        ->validate($data->[$i], $context);
                });
                unless ($v) {
                    $is_valid = 0;
                    last;
                }
            }
            $is_valid;
        });
    } else {
        croak 'invalid `items` definition';
    }
}

1;
