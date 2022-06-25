const post = async (url, data) => {
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify(data),
  })
  return response.json()
}

const get = async (url) => {
  const response = await fetch(url, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
  })
  return response.json() // parses JSON response into native JavaScript objects
}

const mapArtsToTemplates = (template) => (it) => {
  let t = template
  t = t.replaceAll('__company_id__', `company_${it.serial_number}`) // TODO check if there isn't better id, instead of using serial number
  t = t.replace('__value__', it.serial_number)
  const title = `<span class="govuk-!-font-weight-bold">${
    it.name
  }</span>, typ: ${it.type}, dátum doručenia: ${
    it.delivery_date
  }, poradové číslo: ${it.serial_number}, počet listov: ${
    it.raw.pageCount || 0
  }`
  t = t.replace('__title__', title)
  return t
}

const eventHandlerOptionClickEvent = async () => {
  if (!event.target.matches('.autocomplete__option')) return
  event.preventDefault()

  // TODO replace from here, into
  // TODO instead of doing onClick event, copy this code into function `onConfirm`

  const el = event.target
  const input = document.getElementById('subject-search')
  input.value = el.innerText
  // TODO hide search options, check how we do it in ruby project, if there is something already prepare to hide/show
  const ul = event.target.closest('ul')
  ul.classList.add('hidden')
  // TODO call api to get search_acts
  const acts = await get('/public/images/search_acts.json').then(
    (r) => r.result // result is Array
  )
  console.log(acts)
  const box = document.getElementById('acts_box')
  const tActsHeader = document.getElementById('t-acts-header').innerHTML
  const tItem = document.getElementById('t-acts-item').innerHTML
  const arrItems = acts.map(mapArtsToTemplates(tItem)).join(`\n`)
  box.innerHTML = `${tActsHeader}
${arrItems}
`
}

const continueEventHandlerOnClick = async (event) => {
  if (!event.target.matches('[data-submit="true"]')) return
  event.preventDefault()

  // TODO add error validation and validate required elements and return error what is missing etc.
  //
  // TODO test, if you select company, select items,
  // then change the company and select new items, what will happen, if the
  // Make sure that the company list selected items resets with the change of the company.

  const subject = document.getElementById('udaje-subject')
  const signTaker = document.getElementById('udaje-sign-taker')
  const signSender = document.getElementById('udaje-sign-sender')
  const company = document.getElementById('subject-search')
  const compnayAddress = document.getElementById('company-address')
  const actsBox = document.getElementById('acts_box')
  const actsSelectedElems = actsBox.querySelectorAll(
    '.govuk-checkboxes__input:checked'
  )
  const actsSelected = Array.from(actsSelectedElems).map((it) => {
    return it.value
  })
  // TODO make request to get xml
  console.log(actsSelected)
}

const main = async () => {
  document.addEventListener(
    'click',
    function (event) {
      // eventHandlerTODO(event)
      eventHandlerOptionClickEvent(event)
      continueEventHandlerOnClick(event)
    },
    false
  )

  document.addEventListener(
    'change',
    function (event) {
      // eventChangeHandlerTODO(event)
    },
    false
  )
}

main().catch(console.log)
