import {Controller} from 'stimulus';

export default class extends Controller {
    start(event) {
        event.currentTarget.innerText = 'Prebieha prihlasovanie cez eID';
        event.currentTarget.classList.add('govuk-button--disabled');
        event.currentTarget.disabled = 'disabled'
        // TODO spinner class?
        // TODO timeout?
    }
}