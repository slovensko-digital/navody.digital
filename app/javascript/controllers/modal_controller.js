import {Controller} from 'stimulus';

export default class extends Controller {
    static targets = ["modal"]

    close(event) {
        event.preventDefault();
        this.modalTarget.remove();
    }
}
