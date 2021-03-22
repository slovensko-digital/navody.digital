$(document).on('turbolinks:load', function () {
    $("#task_type").change(function () {
        if (this.value === "ExternalLinkTask") {
            $("#external_link_fields").css('display', 'block');
        } else {
            $("#external_link_fields").css('display', 'none');
        }
    });
    // triger change event when user accessed page
    $("#task_type").trigger("change");
});