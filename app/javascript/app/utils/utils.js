export function trustObject(observable) {
  return JSON.parse(JSON.stringify(observable))
}

function addZero(n) {
  if (n <= 9) return '0' + n
  else return n
}

export function formatDataBR(data) {
  let dataAtual = new Date(data)
  let dataFormated =
    addZero(dataAtual.getDate().toString()) +
    '/' +
    addZero(dataAtual.getMonth() + 1).toString() +
    '/' +
    dataAtual.getFullYear()
  return dataFormated
}

export function formatDataHourBR(data) {
  let dataAtual = new Date(data)
  let dataFormated =
    addZero(dataAtual.getDate().toString()) +
    '/' +
    addZero(dataAtual.getMonth() + 1).toString() +
    '/' +
    dataAtual.getFullYear() +
    '  ' +
    addZero(dataAtual.getHours()) +
    ':' +
    addZero(dataAtual.getMinutes())
  return dataFormated
}
