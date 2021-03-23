import {Controller} from 'stimulus';

export default class extends Controller {
    static targets = ["file"]

    downloadFile(event) {
        event.currentTarget.setAttribute('data-downloaded', true)
    }

    checkDownloads(event) {
        const allDownloaded = this.fileTargets.every(file => file.getAttribute('data-downloaded'));
        if (!allDownloaded) {
            const confirmMessage = event.currentTarget.getAttribute('data-confirm-message');
            if (!confirm(confirmMessage)) {
                event.preventDefault();
                event.stopImmediatePropagation();
            }
        }
    }
}
