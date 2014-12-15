package JSON::Schema::Validator::Attributes::Format;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use Carp qw(croak);
use Data::Validate::URI qw();

sub attr_name { 'format' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;

    return 1 unless $context->prims->is_string($data);

    $context->in_attr($class, sub {
        my $format = $schema->{format};

        if ($format eq 'date-time') {
            return _format_date_time($data);
        }

        if ($format eq 'uri') {
            return _format_uri($data);
        }

        # TODO: email, hostname, ipv4, ipv6

        croak sprintf 'invalid format: `%s`', $format;
    });
}

sub _format_date_time {
    my ($data) = @_;
    $data =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})/ ? 1 :  0;
}

sub _format_uri {
    my ($data) = @_;
    Data::Validate::URI::is_uri($data);
}

1;
