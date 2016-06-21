/* globals $*/
"use strict";

$(document).ready(function() {
  var $modal = $("#addressModal");
  var $form = $modal.find("form");
  $form.on('ajax:success', function(event, data) {
    var $this = $(event.target);

    if (data["status"] == "success") {
      window.location.assign(data["redirect_to"])
    } else {
      $form.find(".alert-danger").remove();

      $.each(data["errors"], function() {
        var $p = $("<p>").addClass("alert-danger").text(this);
        $form.prepend($p);
      });
    }
  });
});
