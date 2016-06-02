/* globals $*/
"use strict";

$(document).ready(function() {
  function updatePublishabilityBlock(event, data, initial_state, final_state) {
    if (data.status === "success") {
      var $target_parent = $(event.target).closest("[data-behaviour=" + initial_state + "]");
      $target_parent.attr("class", "hidden");
      $target_parent.siblings("[data-behaviour=" + final_state + "]").attr("class", "shown");
      $target_parent.closest("td").siblings("[data-behaviour=publisher]").text(data.publisher);
    } else {
      var modal = $('#errorModal');
      var $modalbody = modal.find('.modal-body');
      $modalbody.empty();
      modal.find('.modal-title').text('Following errors prevented this from being ' + final_state + ': ');
      $.each(data.errors, function(index, value) {
        var $err = $("<p>").attr("class", "alert-danger").text(value);
        $modalbody.append($err);
      });

      modal.modal();
    }
    event.preventDefault();
  }

  function startSpinner(element) {
    $(element).siblings("i").removeClass("hidden");
  }

  function stopSpinner(element) {
    $(element).siblings("i").addClass("hidden");
  }

  $('[data-behaviour=publishable] a, [data-behaviour=unpublishable] a').on('ajax:before', function() {
    startSpinner(this);
  });

  $('[data-behaviour=publishable] a, [data-behaviour=unpublishable] a').on('ajax:complete', function(xhr, status) {
    stopSpinner(this);
  });

  $('[data-behaviour=publishable] a').on('ajax:success', function(event, data) {
    updatePublishabilityBlock(event, data, "publishable", "unpublishable");
  });

  $('[data-behaviour=unpublishable] a').on('ajax:success', function(event, data) {
    updatePublishabilityBlock(event, data, "unpublishable", "publishable");
  });
});
