$(document).on('turbolinks:load', function () {
    var elm = document.querySelector('.ep-vote-app');
    if (elm) {
        elm.remove();
    }
});