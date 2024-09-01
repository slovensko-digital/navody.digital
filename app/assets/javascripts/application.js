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
//= require cookieconsent.min
//= require newsletter_sign_up
//= require jscookie

$(document).on("turbolinks:load", function () {
  // Initialize Cookie Bar
  window.cookieconsent.initialise({
    palette: {
      popup: {
        background: "#1d1e21",
      },
      button: {
        background: "#4cae18",
      },
    },
    theme: "classic",
    content: {
      message:
        "Tento web používa súbory cookie na poskytovanie služieb.",
      dismiss: "Súhlasím",
    },
    showLink: false,
  });

  var activeTopicClose = document.querySelector(".js__active-topic-close");
  if (activeTopicClose) {
    activeTopicClose.addEventListener("click", function (e) {
      e.preventDefault();
      Cookies.set("current_topic", activeTopicClose.dataset.key, {
        expires: 365,
      });
      document
        .querySelector(".active-topic")
        .classList.add("active-topic__hidden");
    });
  }

  var changeNotificationDateLink = document.querySelector("#change-notification-date-link");
  if (changeNotificationDateLink) {
    changeNotificationDateLink.addEventListener("click", function (e) {
      e.preventDefault();
      $("#change-notification-date").removeClass("sdn-appear-link-hide");
      $("#deadline-notifications-info").addClass("sdn-appear-link-hide");
    });
  }

  var changeNotificationDateClose = document.querySelector("#change-notification-date-close");
  if (changeNotificationDateClose) {
    changeNotificationDateClose.addEventListener("click", function (e) {
      e.preventDefault();
      $("#change-notification-date").addClass("sdn-appear-link-hide");
      $("#deadline-notifications-info").removeClass("sdn-appear-link-hide");
    });
  }
});
