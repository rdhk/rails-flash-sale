/* globals $*/
"use strict";

$(document).ready(function() {
  // alert("meow1");
  // FIXME_AB: User a better selector, this selector is not we use 
  $('[data-li-id]').on('ajax:success', function(event, data) {
    var $this = $(event.target);
    // FIXME_AB: use closest tr with some selector, its too generic
    $this.closest("tr").remove();
    // FIXME_AB: give a data-behaviour to strong tag and find it in the scope of $this not in full html document
    $("[data-behaviour=total]").html('<strong>' + data.total + '</strong>');
    if (data.total == "Rs0.00") {
      $("[data-behaviour=checkout]").hide();
    }
  });
});
