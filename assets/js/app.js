// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.


import "phoenix_html";

export const Planet = {
  disableSubmitButton() {
    const submitButton = document.getElementById("submitButton");

    submitButton.setAttribute("disabled", "");
    submitButton.classList.add("opacity-50", "cursor-not-allowed");
  },
  openFeedMenu(e, id) {
    Array.from(document.getElementsByClassName("dropdown-content"))
      .forEach(dropdown => 
        dropdown.id === `${id}-dropdown`
        ? dropdown.classList.toggle("hidden")
        : dropdown.classList.add("hidden")
      );

    e.stopPropagation();
  },
  setupCloseFeedMenuHandler() {
    window.onclick = function(event) {
      if (!event.target.matches('.dropdown-button')) {
        Array.from(document.getElementsByClassName("dropdown-content"))
          .forEach(dropdown => dropdown.classList.add('hidden'));
      }
    }
  }
}

