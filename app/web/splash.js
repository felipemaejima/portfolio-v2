// Remove a splash do index.html no primeiro frame do Flutter. Arquivo separado
// (não inline) para a CSP de produção permitir só script-src 'self'.
window.addEventListener("flutter-first-frame", function () {
  var s = document.getElementById("splash");
  if (s) s.remove();
});
