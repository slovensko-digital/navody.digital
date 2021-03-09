$(document).ready(function() {
  $("#task_type").change(function() {
    if (this.value != "ExternalLinkTask") {
      //$("#task_url").attr('readonly', 'true');
      //$("#task_url_title").attr('readonly', 'true');
      $("#task_url").attr('disabled', 'true');
      $("#task_url_title").attr('disabled', 'true');
    }
    else {
      //$("#task_url").removeAttr('readonly');
      //$("#task_url_title").removeAttr('readonly');
      $("#task_url").removeAttr('disabled');
      $("#task_url_title").removeAttr('disabled');
    }
  });
  // triger change event when user accessed page
  $("#task_type").trigger("change")
});