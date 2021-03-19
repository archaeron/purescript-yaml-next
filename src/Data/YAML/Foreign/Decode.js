"use strict";

var yaml = require('js-yaml');

exports.parseYAMLImpl = function(left, right, str) {
  try {
    return right(yaml.load(str));
  } catch (e) {
    return left(e.toString());
  }
};
