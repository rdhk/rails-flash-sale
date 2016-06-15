/* globals $*/
"use strict";

$(document).ready(function() {
  // FIXME_AB: User a better selector, this selector is not we use - done
  $('[data-behaviour=deletelineitem]').on('ajax:success', function(event, data) {
    var $this = $(event.target);

    $this.closest("tr[data-behaviour=lineitem_row]").remove();
    $("[data-behaviour=total]").html(data.total);
    if (data.total == "Rs0.00") {
      $("[data-behaviour=checkout]").hide();
    }
  });
});
