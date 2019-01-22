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
        if (data.result !== undefined && data.result.result === 'success') {
          form.remove();
          $('#newsletter-success').show();
        }
      },
      complete: function () {
        button.innerHTML = 'Prihlásiť'
      }
    });
  });
});
