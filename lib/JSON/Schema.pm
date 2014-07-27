package JSON::Schema;
use 5.008001;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use URI;
use JSON::XS;
use JSON::Schema::Validator;

use Class::Accessor::Lite (
    ro => [qw(schema parent_schema)],
);

our $VERSION = "0.01";

# TODO namespace, references

sub new {
    my ($class, $schema, $parent_schema) = @_;

    # my $id = do {
    #     if ($schema->{id}) {
    #         my $uri = URI->new($schema->{id});
    #     }
    # };

    return bless {
        schema        => $schema,
        parent_schema => $parent_schema,
    }, $class;
}

sub validator {
    my ($self, $options) = @_;
    return JSON::Schema::Validator->new($self, $options);
}

sub as_position {
    my ($self) = @_;
}

sub to_hash {
    my ($self) = @_;
}

sub to_json {
    my ($self) = @_;
}

1;
__END__

=encoding utf-8

=head1 NAME

JSON::Schema - It's new $module

=head1 SYNOPSIS

    use JSON::Schema;

=head1 DESCRIPTION

JSON::Schema is ...

=head1 LICENSE

Copyright (C) pokutuna.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

pokutuna E<lt>popopopopokutuna@gmail.comE<gt>

=cut
