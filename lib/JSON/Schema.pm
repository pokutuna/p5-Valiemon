package JSON::Schema;
use 5.008001;
use strict;
use warnings;

use JSON::XS;

use JSON::Schema::Validator;

use Class::Accessor::Lite (
    ro => [qw(schema)],
);

our $VERSION = "0.01";

# TODO namespace, references

sub new {
    my ($class, $schema) = @_;
    return bless {
        schema => $schema
    }, $class;
}

sub validator {
    my ($self) = @_;
    return JSON::Schema::Validator->new($self->schema);
}

sub reference {
    my ($self) = @_;
    return 'ROOT'; # TODO implemention
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
