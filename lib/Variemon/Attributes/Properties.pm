package Variemon::Attributes::Properties;
use strict;
use warnings;
use utf8;
use parent qw(Variemon::Attributes);

use Carp qw(croak);
use Clone qw(clone);
use List::MoreUtils qw(all);
use Variemon;

sub attr_name { 'properties' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    $context->in_attr($class, sub {
        return 1 unless ref $data eq 'HASH'; # ignore

        my $properties = $schema->sub_schema('properties');
        unless ($properties->is_hash) {
            croak sprintf '`properties` must be an object at %s', $context->position
        }

        my $is_valid = 1;
        for my $prop (keys %{$properties->raw}) {
            my $sub_schema = $properties->sub_schema($prop);

            # fill in default
            unless (exists $data->{$prop}) {
                my $default = $sub_schema->get_default;
                if ($default) {
                    $data->{$prop} = clone($default);
                }
                next; # skip
            }

            my $sub_data = $data->{$prop};
            my $res = $context->in($prop, sub {
                $context->sub_validator($sub_schema)->validate($sub_data, $context);
            });

            if (!$res) {
                $is_valid = 0;
                last;
            }
        }

        $is_valid;
    });
}

1;
