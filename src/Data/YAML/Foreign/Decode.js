import yaml from 'js-yaml'

export function parseYAMLImpl (left, right, str) {
  try {
    return right(yaml.load(str))
  }
  catch (e) {
    return left(e.toString())
  }
}
