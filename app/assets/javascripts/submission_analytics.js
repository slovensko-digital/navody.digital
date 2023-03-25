const templateId = () => {
  return JSON.parse(document.getElementById('submission_raw_extra')?.value)?.template_id;
}

const plausibleEvent = (event) => {
  if (typeof plausible !== 'undefined') {
    plausible(event, { props: { template_id: templateId() } });
  }
}

document.querySelector('[name="commit"]').addEventListener('click', () => {
  plausibleEvent('Submission sent to email');
})

document.querySelector('[name="skip_subscribe"]').addEventListener('click', () => {
  plausibleEvent('Submission downloaded');
})
