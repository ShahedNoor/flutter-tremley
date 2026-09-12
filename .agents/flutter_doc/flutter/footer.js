(function() {
  var span = document.querySelector('footer>span');
  if (span) {
    span.innerText = 'Flutter 3.42.0-1.0.pre-34 • 2026-02-18 14:23 • 90673a4eef • stable';
  }
  var sourceLink = document.querySelector('a.source-link');
  if (sourceLink) {
    sourceLink.href = sourceLink.href.replace('/main/', '/90673a4eef/');
  }
})();
