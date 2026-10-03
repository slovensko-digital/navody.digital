import {Controller} from 'stimulus';

export default class extends Controller {
    start(event) {
        event.currentTarget.innerText = 'Prebieha prihlasovanie cez eID';
        event.currentTarget.setAttribute('disabled', 'disabled');
        event.currentTarget.setAttribute('aria-disabled', 'true');
        // TODO spinner class?
        // TODO timeout?
    }
}