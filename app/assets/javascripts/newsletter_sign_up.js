$(document).on('turbolinks:load', function () {
  $('#newsletter-form').submit(function (evt) {
    evt.preventDefault();

    var form = $(evt.target);
    var data = form.serialize();
    var button = form.find('button')[0];
    button.innerHTML = 'Prihlasujem...';

    $.ajax({
      type: 'POST',
      url: form.data('action'),
      data: data,
      success: function () {
          form.remove();
          $('#newsletter-success').show();
          if ($('#newsletter-warning').is(':visible')) {
            $('#newsletter-warning').hide();
          }
      },
      error: function () {
          var warningText = 'Prihlásenie do newslettera sa nepodarilo. Prosím skúste znova.';
          $('#newsletter-warning').show();
          $('#newsletter-warning strong').text(warningText);
      },
      complete: function () {
        button.innerHTML = 'Prihlásiť'
      }
    });
  });
});
