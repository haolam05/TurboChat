import consumer from "channels/consumer";

let resetFunc;
let timer = 0;

consumer.subscriptions.create("AppearanceChannel", {
  initialized() {},                   // initialize on page load(refresh page event) even when restart server, initialzied won't be called again
  
  connected() {                       // Called whenever the subscription is ready for use on the server
    console.log("Connected");
    resetFunc = () => this.resetTimer(this.uninstall);
    this.install();
    window.addEventListener("turbo:load", () => this.resetTimer());
  },

  disconnected() {                    // Called when the subscription has been terminated by the server
    console.log("Disconnected");
    this.uninstall();
  },

  rejected() {
    console.log("Rejected");
    this.uninstall();
  },

  received(data) {                    // Called when there's incoming data on the websocket for this channel
  },

  online() {
    console.log("online");
    this.perform("online");           // #online method in appearance_channel.rb
  },

  away() {
    console.log("away");
    this.perform("away");             // #away method in appearance_channel.rb
  },

  offline() {
    console.log("offline");
    this.perform("offline");          // #offline method in appearance_channel.rb
  },

  uninstall() {
    const shouldRun = document.getElementById("appearance_channel"); // grabs the <div> id="appearance_channel"> from home/index page 
    if (!shouldRun) {                 // <div> not yet visible, ex: during page load => want users to be offline
      clearTimeout(timer);
      this.perform("offline");
    }
  },

  install() {
    console.log("Install");

    window.removeEventListener("load", resetFunc);
    window.removeEventListener("DOMContentLoaded", resetFunc);
    window.removeEventListener("click", resetFunc);
    window.removeEventListener("keydown", resetFunc);

    window.addEventListener("load", resetFunc);
    window.addEventListener("DOMContentLoaded", resetFunc);
    window.addEventListener("click", resetFunc);
    window.addEventListener("keydown", resetFunc);
    
    this.resetTimer();
  },
  
  resetTimer() {
    this.uninstall();
    const shouldRun = document.getElementById("appearance_channel");

    if (!!shouldRun) {
      this.online();
      clearTimeout(timer);

      const timeInSeconds = 5;
      const milliseconds = 1000;
      const timeInMilliseconds = timeInSeconds * milliseconds;

      timer = setTimeout(this.away.bind(this), timeInMilliseconds);
    } // add this waiting time to #away => 5sec if no detected events => away
  },
});