import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vonage"
export default class extends Controller {
  connect() {
    this.apiKey     = document.querySelector('#videos').dataset.vonageApiKey
    this.sessionId  = document.querySelector('#videos').dataset.vonageSessionId
    this.token      = document.querySelector('#videos').dataset.vonageToken
    this.name       = document.querySelector('#videos').dataset.vonageName
  }

  disconnect() {
    if (this.session) {
      this.session.disconnect()
      document.getElementById("messages").classList.toggle('d-none')
      document.getElementById("msg_form").classList.toggle('d-none')
      // document.getElementById("videos").classList.add('bi')
      // document.getElementById("videos").classList.add('bi-camera-video')
      // document.getElementById("videos").classList.add('video-button')
      document.querySelector('#videos').dataset.action = 'click->vonage#initializeSession'
    }
  }

  // *******************************************************************
  initializeSession() {
    this.session = OT.initSession(this.apiKey, this.sessionId)          // create session
    this.session.on('streamCreated', this.streamCreated.bind(this))     // create subscriber --- Subscribe to a newly created stream

    this.publisher = OT.initPublisher(this.element, {                   // create publisher
      insertMode: 'append',
      width: '100%',
      height: '100%',
      name: this.name,
    }, this.handleError.bind(this))

    this.session.connect(this.token, this.streamConnected.bind(this))   // connect with publisher through created token
    document.getElementById("messages").classList.add('d-none')
    document.getElementById("msg_form").classList.add('d-none')
    // document.getElementById("videos").classList.toggle('bi')
    // document.getElementById("videos").classList.toggle('bi-camera-video')
    // document.getElementById("videos").classList.toggle('video-button')
    document.querySelector('#videos').dataset.action = ''
    document.getElementById("video_button").classList.add('d-none')
  }
  // *******************************************************************

  streamConnected(error) {
    if (error) {
      this.handleError(error)
    } else {
      this.session.publish(this.publisher, this.handleError.bind(this))
    }
  }

  streamCreated(event) {
    this.session.subscribe(event.stream, this.element, {
      insertMode: 'append',
      width: '100%',
      height: '100%',
    }, this.handleError.bind(this))
  }

  handleError(error) {
    if (error) {
      console.error(error.message)
    }
  }
}