use strict;
use warnings;
use lib 't/lib/';

use Test::More;

use SuiteRunner;

use Valiemon;

my $runner = SuiteRunner->new;

my @tests = map { glob $_ } qw(
    t/test-suite/tests/draft4/*.json
    t/test-suite/tests/draft4/optional/*.json
);

my %todos = map {
    ($_ => 1)
} qw(
    t/test-suite/tests/draft4/additionalItems.json
    t/test-suite/tests/draft4/additionalProperties.json
    t/test-suite/tests/draft4/allOf.json
    t/test-suite/tests/draft4/anyOf.json
    t/test-suite/tests/draft4/definitions.json
    t/test-suite/tests/draft4/dependencies.json
    t/test-suite/tests/draft4/maxLength.json
    t/test-suite/tests/draft4/maxProperties.json
    t/test-suite/tests/draft4/minLength.json
    t/test-suite/tests/draft4/minProperties.json
    t/test-suite/tests/draft4/not.json
    t/test-suite/tests/draft4/oneOf.json
    t/test-suite/tests/draft4/optional/bignum.json
    t/test-suite/tests/draft4/optional/format.json
    t/test-suite/tests/draft4/optional/zeroTerminatedFloats.json
    t/test-suite/tests/draft4/patternProperties.json
    t/test-suite/tests/draft4/properties.json
    t/test-suite/tests/draft4/ref.json
    t/test-suite/tests/draft4/refRemote.json
    t/test-suite/tests/draft4/type.json
);

for my $test (@tests) {
    subtest $test => sub {
        $runner->run($test, $todos{$test});
    };
}

done_testing;
