// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

window.disableSubmitButton = function() {
   const submitButton = document.getElementById("submitButton");

   submitButton.setAttribute("disabled", "");
   submitButton.classList.add("opacity-50", "cursor-not-allowed");
};
