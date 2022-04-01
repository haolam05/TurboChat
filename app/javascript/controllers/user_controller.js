import { Controller } from "@hotwired/stimulus";

export default class User extends Controller {
  static form = document.getElementById("user_search_form");
  static input = document.getElementById("email_search");
  
  connect() {
    console.log("User Debounce controller connected");
    this.clearParam(User.input);
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      User.form.requestSubmit();
    }, 500);
  }
  // Clear name_search param if form is empty
  clearParam(input) {
    if (input.value === "") {
      const baseURL = location.origin + location.pathname;
      window.history.pushState("", "", baseURL);
    }
  }
}