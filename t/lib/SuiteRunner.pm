package SuiteRunner;
use strict;
use warnings;

use JSON::XS;

use Test::More;
use Valiemon;

sub new {
    my ($class) = @_;

    bless {}, $class;
}

sub run {
    my ($self, $file) = @_;

    my $content = do {
        local $/;
        open my $fh, '<', $file;
        <$fh>;
    };

    my $cases = decode_json($content);

    $self->run_case($_) for @$cases;
}

sub run_case {
    my ($self, $case) = @_;

    my ($description, $schema, $tests) = ($case->{description}, $case->{schema}, $case->{tests});

    my $coder = JSON::XS->new->ascii->pretty->allow_nonref;

    subtest $description => sub {
        my $valiemon = Valiemon->new($schema);
        for my $test (@$tests) {
            my ($description, $data, $valid) = ($test->{description}, $test->{data}, $test->{valid});
            my ($res, $error) = $valiemon->validate($data);
            if (!!$res == !!$valid) {
                pass $description;
            } else {
                fail $description;
                diag "schema: @{[ encode_json($schema) ]}";
                diag "data: @{[ $coder->encode($data) ]}";
                diag "expect: @{[ $valid ? 'valid' : 'invlid' ]}";
            }
        }
    };
}

1;

__END__

=encoding utf-8

=head1 NAME

SuiteRunner - Test Suite Runner

=head1 SYNOPSIS

    use SuiteRunner;

    my $runner = SuiteRunner->new;

    $runner->run('t/test-suite/tests/draft4/allOf.json');

=head1 DESCRIPTION

SuiteRunner is a runnner class for JSON-Schema-Test-Suite ( https://github.com/json-schema/JSON-Schema-Test-Suite ).

=head1 LICENSE

MIT

=cut
