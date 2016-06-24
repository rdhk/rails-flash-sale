/* globals $*/
"use strict";

$(document).ready(function() {
  setTimeout(checkDealStatus, 10000);

  function checkDealStatus() {
    var $dealElement = $("[data-behaviour=deal]");
    $.ajax({
      url: $dealElement.data("url"),
      dataType: "json"
    }).done(function(data) {
      var $newElement = $("<span>").attr({
        class: "label label-danger",
        "data-behaviour": "deal_state"
      });
      if (data.status == "sold_and_expired") {
        $("[data-behaviour=deal_state]").replaceWith($newElement.text("SOLD OUT AND EXPIRED"));
      } else if (data.status == "sold_out") {
        $("[data-behaviour=deal_state]").replaceWith($newElement.text("SOLD OUT"));
      } else if (data.status == "expired") {
        $("[data-behaviour=deal_state]").replaceWith($newElement.text("EXPIRED"));
      }
      setTimeout(checkDealStatus, 10000);
    });

  }
});
