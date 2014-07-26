package JSON::Schema::Validator;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use JSON::Schema::Validator::Attributes qw(attr);

use Class::Accessor::Lite (
    ro => [qw(schema options)],
);

sub new {
    my ($class, $schema, $opts) = @_;

    # TODO should validate own schema
    if ($opts->{validate_schema}) {}
    croak '$schema must be a hashref' unless ref $schema eq 'HASH';

    return bless {
        schema  => $schema,
        options => $opts,
    }, $class;
}

sub validate {
    my ($self, $data) = @_;
    my $schema = $self->schema;
    my $errors = [];

    for my $key (keys %{$schema}) {
        my $attr = attr($key);
        if ($attr) {
            my $is_valid = $attr->validate($schema, $data, $errors);
            push @$errors, $attr->generate_error unless $is_valid;
        }
    }

    my $valid = scalar @$errors ? 0 : 1;
    return $valid;
}

1;
