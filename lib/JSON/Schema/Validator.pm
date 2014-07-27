package JSON::Schema::Validator;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use JSON::Schema::Validator::Primitives;
use JSON::Schema::Validator::Attributes qw(attr);

use Class::Accessor::Lite (
    ro => [qw(schema options prims)],
);

sub new {
    my ($class, $schema, $options) = @_;

    # TODO should validate own schema
    if ($options->{validate_schema}) {}
    croak '$schema must be a hashref' unless ref $schema eq 'HASH';

    # TODO reference $ref keyword

    my $prims = JSON::Schema::Validator::Primitives->new($options);

    return bless {
        schema  => $schema,
        options => $options,
        prims   => $prims,
    }, $class;
}

sub validate {
    my ($self, $data) = @_;
    my $schema = $self->schema;
    my $errors = [];

    for my $key (keys %{$schema}) {
        my $attr = attr($key);
        if ($attr) {
            my $is_valid = $attr->validate($self, $schema, $data, $errors);
            unless ($is_valid) {
                push @$errors, $attr->generate_error($schema, $data);
                next unless $self->options->{collect_errors};
            }
        }
    }

    my $is_valid_all = scalar @$errors ? 0 : 1;
    return wantarray ? ($is_valid_all, $errors) : $is_valid_all;
}

1;
