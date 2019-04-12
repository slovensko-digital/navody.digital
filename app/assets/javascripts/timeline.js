$(document).on('turbolinks:load', function () {
    document.querySelectorAll('.js-sdn-timeline__bullet').forEach(function (node) {
        node.setAttribute('tabindex', '0');
    });
});


$(document).on('#timeline').on('click', '.js-sdn-timeline__bullet', function (event) {
    event.preventDefault();
    this.parentNode.classList.toggle('sdn-timeline__step--dropdown-active');
});

$(document).on('#timeline').on('focusout', '.js-sdn-timeline__bullet', function (event) {
    event.preventDefault();

    setTimeout(function () {
        this.parentNode.classList.remove('sdn-timeline__step--dropdown-active')
    }.bind(this), 200)
});