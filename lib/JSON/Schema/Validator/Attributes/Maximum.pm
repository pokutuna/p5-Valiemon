package JSON::Schema::Validator::Attributes::Maximum;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

sub attr_name { 'maximum' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    my $max = $schema->{maximum};
    $context->in_attr($class, sub {
        $data <= $max ? 1 : 0;
    });
}

1;
