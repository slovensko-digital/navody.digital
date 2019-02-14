$(document).on('turbolinks:load', function () {
  $('#submission-link').click(function (evt) {
    $(this).addClass('govuk-button--disabled')
  });
});
