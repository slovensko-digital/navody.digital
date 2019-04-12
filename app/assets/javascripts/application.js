// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require activestorage
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function () {
    // TODO make sure forEach works everywhere (polyfill?)

    // Find all buttons with [role=button] on the document to enhance.
    new window.navodyDigitalFrontend.Button(document).init();

    // Find all global accordion components to enhance.
    var $accordions = document.querySelectorAll('[data-module="accordion"]');
    $accordions.forEach(function ($accordion) {
        new window.navodyDigitalFrontend.Accordion($accordion).init()
    });

    // Find all global details elements to enhance.
    var $details = document.querySelectorAll('details');
    $details.forEach(function ($detail) {
        new window.navodyDigitalFrontend.Details($detail).init()
    });

    var $characterCount = document.querySelectorAll('[data-module="character-count"]');
    $characterCount.forEach(function ($characterCount) {
        new window.navodyDigitalFrontend.CharacterCount($characterCount).init()
    });

    var $checkboxes = document.querySelectorAll('[data-module="checkboxes"]');
    $checkboxes.forEach(function ($checkbox) {
        new window.navodyDigitalFrontend.Checkboxes($checkbox).init()
    });

    // Find first error summary module to enhance.
    var $errorSummary = document.querySelector('[data-module="error-summary"]');
    new window.navodyDigitalFrontend.ErrorSummary($errorSummary).init();

    // Find first header module to enhance.
    var $toggleButton = document.querySelector('[data-module="header"]');
    new window.navodyDigitalFrontend.Header($toggleButton).init();

    var $radios = document.querySelectorAll('[data-module="radios"]');
    $radios.forEach(function ($radio) {
        new window.navodyDigitalFrontend.Radios($radio).init()
    });

    var $tabs = document.querySelectorAll('[data-module="tabs"]');
    $tabs.forEach(function ($tabs) {
        new window.navodyDigitalFrontend.Tabs($tabs).init()
    });

    // Find first sdn header module to enhance.
    new window.navodyDigitalFrontend.SdnHeader(document.querySelector('[data-module="sdn-header"]')).init();

    var $appearLinks = document.querySelectorAll('[data-module="sdn-appear-link"]');
    $appearLinks.forEach(function ($link) {
        new window.navodyDigitalFrontend.SdnAppearLink($link).init()
    })
});
