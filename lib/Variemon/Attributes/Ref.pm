package Variemon::Attributes::Ref;
use strict;
use warnings;
use utf8;
use parent qw(Variemon::Attributes);

use Carp qw(croak);

sub attr_name { '$ref' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    my $ref = $schema->raw->{'$ref'};
    my $sub_schema = $schema->resolve_ref($ref);

    $context->in_attr($class, sub {
        $context->sub_validator($sub_schema)->validate($data, $context);
    });
}

1;
