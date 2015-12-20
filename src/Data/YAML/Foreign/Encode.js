"use strict";

// module Data.YAML.Foreign.Encode

var yaml = require('js-yaml');

exports.jsNull = null;

exports.objToHash =
	function(valueToYAMLImpl, fst, snd, obj)
	{
	    var hash = {};
	    for(var i = 0; i < obj.length; i++) {
	        hash[fst(obj[i])] = valueToYAMLImpl(snd(obj[i]));
	    }
	    return hash;
	};

exports.toYAMLImpl =
	function(a)
	{
		return yaml.safeDump(a);
	}
