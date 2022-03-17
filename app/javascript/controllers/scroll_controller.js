import { Controller } from "@hotwired/stimulus";

export default class extends Controller {                                   // automatically scroll to end when we have new mesages
    initialize() {                                                          // however, we do not want to scroll the user down if he/she is watching older messages
        this.resetScrollWithoutThreshold(messages);                         // scroll down to new messages if within 500pixels to client
    }

    // start
    connect() {
        console.log("Connected")
        const messages = document.getElementById("messages");
        messages.addEventListener("DOMNodeInserted", this.resetScroll);     // DOMNodeInsrted is when DOM inserts a new message
    }

    // stop
    disconnect() {
        console.log("Disconnected")
        messages.removeEventListener("DOMNodeInserted", this.resetScroll);
    }

    // custom function
    resetScroll() {
        const bottomOfScroll = messages.scrollHeight - messages.clientHeight;
        const upperScrollThreshold = bottomOfScroll - 500;  // 500 pixels

        if (messages.scrollTop > upperScrollThreshold) {
            messages.scrollTop = messages.scrollHeight - messages.clientHeight;
        }
    }

    resetScrollWithoutThreshold(messages) {
        messages.scrollTop = messages.scrollHeight - messages.clientHeight;
    }
}