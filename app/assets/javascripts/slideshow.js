/* globals $*/
"use strict";


$(document).ready(function() {

  var slideshowConatainer = $("[data-behaviour=slideshow]");
  var slideshowObject = new Slideshow(slideshowConatainer, 2);
  slideshowObject.init();
});

var Slideshow = function(container, seconds) {

  this.$container = container;
  this.seconds = seconds;
  this.$children = this.$container.children();
  this.len = this.$children.length;
  this.current_index = 0;
};

Slideshow.prototype.init = function() {
  this.createNavArea();
  this.$children.hide();

  var $current_item = this.$children.first();
  $current_item.show();

  this.addCurrentClass();
  setInterval(this.changeItem.bind(this), this.seconds * 1000);

};

Slideshow.prototype.addCurrentClass = function() {
  $(this.$thumbnailList.children()[this.current_index]).find("img").addClass("currentli");
};


Slideshow.prototype.changeItem = function() {
  var $current_item = $(this.$children[this.current_index]);
  $current_item.fadeOut(1000, this.fadeOutCallback.bind(this));
};

Slideshow.prototype.fadeOutCallback = function() {
  var $next_item;
  if (this.current_index == (this.len - 1)) {
    this.current_index = 0;
  } else {
    this.current_index = this.current_index + 1;
  }
  $next_item = $(this.$children[this.current_index]);
  $next_item.fadeIn(1000);
  $(this.$thumbnailList.children()).find("img").removeClass("currentli");
  this.addCurrentClass();
};

Slideshow.prototype.createNavArea = function() {
  this.$frag = $(document.createDocumentFragment());
  this.$thumbnailList = $("<ul>", {
    "class": "navArea"
  });
  this.$frag.append(this.$thumbnailList);
  this.createThumbnail();
  this.$frag.insertAfter(this.$container);
};

Slideshow.prototype.createThumbnail = function() {
  var _this = this;
  this.$children.each(function(i, item) {
    var source = $(item).find("img").attr("src");
    var $img = $("<img>", {
      src: source
    });
    var $li = $("<li>");
    $li.append($img);
    _this.$thumbnailList.append($li);

  });


};
