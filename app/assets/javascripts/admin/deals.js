// FIXME_AB: document .ready - done
// FIXME_AB: jshint validate - done
/* globals $*/
"use strict";

function handleAjaxEvent(event, data, initial_state, final_state) {
  if (data.status == "success") {
    var $target_parent = $(event.target).closest("[data-behaviour=" + initial_state + "]");
    $target_parent.attr("class", "hidden");
    $target_parent.siblings("[data-behaviour=" + final_state + "]").attr("class", "shown");
  } else {
    var modal = $('#errorModal');
    var $modalbody = modal.find('.modal-body');
    $modalbody.empty();
    modal.find('.modal-title').text('Following errors prevented this from being ' + final_state + ': ');
    $.each(data.errors, function(index, value) {
      var $err = $("<p>").attr("class", "alert alert-danger").text(value);
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

// FIXME_AB: Also use start and complete event to show spinner - done

$(document).ready(function() {

  $('[data-behaviour=publishable] a, [data-behaviour=unpublishable] a').on('ajax:before', function() {
    startSpinner(this);
    // console.log(this);
  });

  $('[data-behaviour=publishable] a, [data-behaviour=unpublishable] a').on('ajax:complete', function(xhr, status) {
    stopSpinner(this);
    // console.log(this);
  });

  $('[data-behaviour=publishable] a').on('ajax:success', function(event, data) {
    handleAjaxEvent(event, data, "publishable", "unpublishable");
  });

  $('[data-behaviour=unpublishable] a').on('ajax:success', function(event, data) {
    handleAjaxEvent(event, data, "unpublishable", "publishable");
  });
});
