//= require ../vendor/jquery-2.1.4.min.js
//= require ../vendor/bootstrap/bootstrap.min
//= require vanilla-masker.min
//= require smoothscroll.min


VMasker(document.querySelector("#mask-phone")).maskPattern("(99) 99999-9999");

document.addEventListener('DOMContentLoaded', function() {
  var elements = ['.js-contact', '.js-process', '.js-projects', '.js-talk'];

  elements.forEach(function (element) {
    var btn = document.querySelector(element + '-btn');
    console.log(btn);
    btn.addEventListener('click', function (e) {
      var destine = document.querySelector(element);
      console.log(destine);
      window.smoothScroll(destine, 2000);
    });
  });

  setTimeout( function(){ var flash = document.querySelector('.flash'); if(flash){flash.style.display = 'none';}}, 6000);

});
