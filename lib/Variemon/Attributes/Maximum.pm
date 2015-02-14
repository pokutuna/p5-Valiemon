package Variemon::Attributes::Maximum;
use strict;
use warnings;
use utf8;
use parent qw(Variemon::Attributes);

sub attr_name { 'maximum' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    my $max = $schema->prop('maximum');
    my $exclusive = $schema->prop('exclusiveMaximum') || 0;
    $context->in_attr($class, sub {
        no warnings 'numeric';
        $exclusive ? $data < $max : $data <= $max;
    });
}

1;
