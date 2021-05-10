export function trustObject(observable){
  return JSON.parse(JSON.stringify(observable))
}