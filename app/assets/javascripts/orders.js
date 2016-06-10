/* globals $*/
"use strict";

$(document).ready(function() {
  // alert("meow1");
  $('[data-li-id]').on('ajax:success', function(event, data) {
    var $this = $(event.target);
    $this.closest("tr").remove();
    $("[data-behaviour=total]").html('<strong>' + data.total + '</strong>');
    if (data.total == "Rs0.00") {
      $("[data-behaviour=checkout]").hide();
    }
  });
});
