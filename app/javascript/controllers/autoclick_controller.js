import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";

// Connects to data-controller="autoclick"
export default class Autoclick extends Controller {
  options = {
    threshold: 0,
  };
  static messagesContainer;
  static topMessage;
  static throttling = false;

  connect() {
    console.log("Connected to Autoclick!");
    useIntersection(this, this.options);
  }

  /**
   * On appear, click the element and scroll to the previous top of the message container.
   */
  appear(entry) {
    if (!Autoclick.throttling) {
      Autoclick.messagesContainer =
        document.getElementById("messages-container");
      Autoclick.topMessage = Autoclick.messagesContainer.children[0];
      Autoclick.throttling = true;
      Autoclick.throttle(this.element.click(), 300);            // this == whatever called autoclick controller --- the load messages button we created
      
      setTimeout(() => {                                        // click this button --- make sure click no more than 1 time every 300ms
        Autoclick.topMessage.scrollIntoView({
          behavior: "auto",                                     // smooth || auto || ...
          block: "end",                                         // center || end  || start || ...
        });
        console.log("Scrolling");
        Autoclick.throttling = false;
      }, 250);
    }
  }

  /**
   * Throttle the click function.
   * @param {Function} func The function to throttle.
   * @param {Number} wait The time to wait before executing the function.
   */
  static throttle(func, wait) { // func is the click action
    let timeout = null;
    let previous = 0;

    let later = function () {
      previous = Date.now();
      timeout = null;
      func();
    };

    return function () {
      let now = Date.now();
      let remaining = wait - (now - previous);
      if (remaining <= 0 || remaining > wait) {
        if (timeout) {
          clearTimeout(timeout);
        }

        later();
      } else if (!timeout) {
        //null timeout -> no pending execution

        timeout = setTimeout(later, remaining);
      }
    };
  }
}