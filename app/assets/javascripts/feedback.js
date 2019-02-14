$(document).on('turbolinks:load', function () {
    $('#feedback-yes').click(function(e) {
        fireAnalyticsFeedback(e, 'Yes');
    });

    $('#feedback-no').click(function(e) {
        fireAnalyticsFeedback(e, 'No');
    });

    function fireAnalyticsFeedback(e, eventAction) {
        if (typeof ga === 'function') {
            ga('send', 'event', 'Feedback', eventAction);
        }
        $('#feedback-question').hide();
        $('#feedback-answered').show();
        e.preventDefault();
    }
});
