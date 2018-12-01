var ready = function() {

    $('.js-close-form').on('click', function(event) {
        var $form_id = $(this).closest("form").attr('id')
        $('#'+$form_id).hide();
    });
    
    $('#autoform-2-show').on('click',function(event)

    {
        $('#autoform-form-2').show();
        
    });

    $('#autoform-3-show').on('click',function(event)

    {
        $('#autoform-form-3').show();
        
    });
    
    $('#autoform-form-1').submit(function() {

        if ($('#autoform-email').val() == '' || $('#autoform-domain').val() == '') {
            $('#autoform-form-sent').hide();
            if ($('#autoform-email').val() == '') {
                $('#autoform-email').parent('.form-group').addClass('has-error');
            }
            else {
                $('#autoform-email').parent('.form-group').removeClass('has-error');
            }
            if ($('#autoform-domain').val() == '') {
                $('#autoform-domain').parent('.form-group').addClass('has-error');
            }
            else {
                $('#autoform-domain').parent('.form-group').removeClass('has-error');
            }
            $('#autoform-error').show();

            return false;
        }
        else {
            $('#autoform-error').hide();
            $('#autoform-email').parent('.form-group').removeClass('has-error');
            $('#autoform-domain').parent('.form-group').removeClass('has-error');
            $('#autoform-form').hide();
            $('#autoform-form-sent').show();

            ga('send', 'event', 'Autoform', 'Registration');
               // alert('Dakujeme za nazor');
               $('.js-prompt-questions').hide();
               $('.js-prompt-success').show();
               $('#autoform-form-1').hide();
               return true;
           }
       });
$('#autoform-form-2').submit(function() {
    if ($('#autoform-email').val() == '' || $('#autoform-domain').val() == '') {
        $('#autoform-form-sent').hide();
        if ($('#autoform-email').val() == '') {
            $('#autoform-email').parent('.form-group').addClass('has-error');
        }
        else {
            $('#autoform-email').parent('.form-group').removeClass('has-error');
        }
        if ($('#autoform-domain').val() == '') {
            $('#autoform-domain').parent('.form-group').addClass('has-error');
        }
        else {
            $('#autoform-domain').parent('.form-group').removeClass('has-error');
        }
        $('#autoform-error').show();

        return false;
    }
    else {
        $('#autoform-error').hide();
        $('#autoform-email').parent('.form-group').removeClass('has-error');
        $('#autoform-domain').parent('.form-group').removeClass('has-error');
        $('#autoform-form').hide();
        $('#autoform-form-sent').show();

        ga('send', 'event', 'Autoform', 'Registration');
        $('.js-prompt-questions').hide();
        $('.js-prompt-success').show();
        $('#autoform-form-2').hide();
        return true;
    }
});
$('#autoform-form-3').submit(function() {
    if ($('#autoform-email').val() == '' || $('#autoform-domain').val() == '') {
        $('#autoform-form-sent').hide();
        if ($('#autoform-email').val() == '') {
            $('#autoform-email').parent('.form-group').addClass('has-error');
        }
        else {
            $('#autoform-email').parent('.form-group').removeClass('has-error');
        }
        if ($('#autoform-domain').val() == '') {
            $('#autoform-domain').parent('.form-group').addClass('has-error');
        }
        else {
            $('#autoform-domain').parent('.form-group').removeClass('has-error');
        }
        $('#autoform-error').show();

        return false;
    }
    else {
        $('#autoform-error').hide();
        $('#autoform-email').parent('.form-group').removeClass('has-error');
        $('#autoform-domain').parent('.form-group').removeClass('has-error');
        $('#autoform-form').hide();
        $('#autoform-form-sent').show();

        ga('send', 'event', 'Autoform', 'Registration');
        $('.js-prompt-questions').hide();
        $('.js-prompt-success').show();
        $('#autoform-form-3').hide();
        return true;
    }
});
}
$(document).ready(ready);
    //$(document).on('turbolinks:load',ready);