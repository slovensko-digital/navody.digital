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
      dataType: 'json',
      success: function (data) {
        if (data.result !== undefined) {
          if (data.result.result === 'success') {
            form.remove();
            $('#newsletter-success').show();
            if ($('#newsletter-warning').is(':visible')) {
              $('#newsletter-warning').hide();
            }
          } else {
            let warningText;
            if (data.result.result === 'emailExist') {
              warningText = data.result.exist_err_msg;
            } else if (data.result.result === 'invalidEmail') {
              warningText = data.result.invalid_err_msg;
            } else {
              warningText = 'Prihlásenie do newslettera sa nepodarilo. Prosím skúste znova.'
            }
            $('#newsletter-warning').show();
            $('#newsletter-warning strong').text(warningText);
          }
        }
      },
      complete: function () {
        button.innerHTML = 'Prihlásiť'
      }
    });
  });
});
