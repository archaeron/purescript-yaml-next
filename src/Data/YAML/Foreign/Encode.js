import yaml from 'js-yaml'

export const jsNull = null

export function objToHash (valueToYAMLImpl, fst, snd, obj) {
  const hash = {}

  for(let i = 0; i < obj.length; i++) {
    hash[fst(obj[i])] = valueToYAMLImpl(snd(obj[i]))
  }

  return hash
}

export function toYAMLImpl (a) {
	// noCompatMode does not support YAML 1.1
	return yaml.dump(a, {noCompatMode : true})
}
