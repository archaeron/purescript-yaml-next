"use strict";

// module Data.YAML.Foreign.Decode

var yaml = require('js-yaml');

exports.parseYAMLImpl = function(left, right, str)
    {
        try
        {
            return right(yaml.safeLoad(str));
        }
        catch (e)
        {
            return left(e.toString());
        }
    };
