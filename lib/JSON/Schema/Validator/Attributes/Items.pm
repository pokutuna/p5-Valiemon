package JSON::Schema::Validator::Attributes::Items;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use Carp qw(croak);
use List::MoreUtils qw(all);
use JSON::Schema::Validator;

sub attr_name { 'items' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    return 1 unless ref $data eq 'ARRAY'; # ignore

    my $items = $schema->{items};
    if (ref $items eq 'HASH') {
        # schema
        return $context->in_attr($class, sub {
            my $is_valid = all {
                JSON::Schema::Validator->new(
                    $items,
                    $context->rv->options,
                )->validate($_, $context);
            } @$data;
            $is_valid;
        });
    } elsif (ref $items eq 'ARRAY') {
        # index base
        return $context->in_attr($class, sub {
            my $is_valid = 1;
            for (my $i = 0; $i < @$items; $i++) {
                my $v = $context->in($i, sub {
                    JSON::Schema::Validator->new(
                        $items->[$i],
                        $context->rv->options,
                    )->validate($data->[$i], $context);
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
    # my $is_valid = all {
    #     my $key = $_;
    #     my $sub_data = $data->{$key};
    #     my $sub_schema = $properties->{$key};

    #     my $v = $context->in($key, sub {
    #         JSON::Schema::Validator->new(
    #             $sub_schema,
    #             $context->rv->options, # inherit
    #         )->validate($sub_data, $context);
    #     });
    #     $v;
    # } (keys %$properties);
}

1;
