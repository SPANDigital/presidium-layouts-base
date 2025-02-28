// This script re-maps links so they work on a single page.
// Syntax needs to be ES5 compatible to work with WkHtmltoPDF
var articles = document.querySelectorAll("[data-link]");

function isExternalLink(link) {
  var anchor = document.createElement("a");
  anchor.href = link;
  return window.location.hostname !== anchor.hostname;
}

var links = document.getElementsByTagName("a");

for (var i = 0; i < links.length; i++) {
  var link = links[i];
  var href = link.getAttribute("href");

  if (href == null || href === "") {
    continue;
  }

  if (isExternalLink(href)) {
    continue;
  }

  href = href.replace(baseURL, "");

  if (href.indexOf("#") === 0) {
    continue;
  }

  var segments = href.split("/").filter(function(x) {
    return x;
  });

  var anchor = segments.pop();

  if (anchor.indexOf("#") === 0) {
    anchor = anchor.substring(1);
  }

  var match = document.getElementById(anchor);
  if (match) {
    link.href = "#" + anchor;
  }
}
