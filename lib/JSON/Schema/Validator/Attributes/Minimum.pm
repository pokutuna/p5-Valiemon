package JSON::Schema::Validator::Attributes::Minimum;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

sub attr_name { 'minimum' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    my $min = $schema->{minimum};
    $context->in_attr($class, sub {
        $min <= $data ? 1 : 0;
    });
}

1;
