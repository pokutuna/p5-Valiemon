package JSON::Schema::Validator::Attributes::Properties;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use List::MoreUtils qw(all);
use JSON::Schema::Validator;

sub attr_name { 'properties' }

sub validate {
    my ($class, $validator, $schema, $data) = @_;

    return 1 unless $validator->prims->is_object($data); # ignore

    my $properties = $schema->{properties};
    my $is_valid = all {
        my $key = $_;
        my $sub_data = $data->{$key};
        my $sub_schema = $properties->{$key};
        JSON::Schema::Validator->new(
            $sub_schema, +{
                root_validator => $validator->root_validator,
                %{$validator->options},
            }
        )->validate($sub_data);
    } (keys %$properties);

    return $is_valid ? 1 : 0;
}

1;
