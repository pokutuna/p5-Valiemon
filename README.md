[![Build Status](https://travis-ci.org/pokutuna/p5-JSON-Schema-Validator.svg?branch=master)](https://travis-ci.org/pokutuna/p5-JSON-Schema-Validator)
# NAME

Variemon - It's a validation module based on JSON Schema

http://json-schema.org/latest/json-schema-core.html
http://json-schema.org/latest/json-schema-validation.html

This module is under development!
So there are some unimplemented features, and module api will be changed.

# SYNOPSIS

    use Variemon;

    # create instance with schema definition
    my $validator = Variemon->new({
        type => 'object',
        properties => {
            name  => { type => 'string'  },
            price => { type => 'integer' },
        },
        requried => ['name', 'price'],
    });

    # validate data
    my ($res, $error);
    ($res, $error) = $validator->validate({ name => 'unadon', price => 1200 });
    # $res   => 1
    # $error => undef

    ($res, $error) = $validator->validate({ name => 'tendon', price => 'hoge' });
    # $res   => 0
    # $error => object Variemon::ValidationError
    # $error->position => '/properties/price/type'

# LICENSE

MIT

# AUTHOR

pokutuna <popopopopokutuna@gmail.com>
