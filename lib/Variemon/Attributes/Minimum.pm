package Variemon::Attributes::Minimum;
use strict;
use warnings;
use utf8;
use parent qw(Variemon::Attributes);

sub attr_name { 'minimum' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    my $min = $schema->{minimum};
    my $exclusive = $schema->{exclusiveMinimum} || 0;
    $context->in_attr($class, sub {
        no warnings 'numeric';
        $exclusive ? $min < $data : $min <= $data;
    });
}

1;
