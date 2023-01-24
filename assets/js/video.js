import Player from "./player";
import { esc, formatTime } from "./utils";
import { Presence } from "phoenix";

let lastSeenId = 0;

let Video = {
  init(socket, element) {
    if (!element) {
      return;
    }
    let playerId = element.getAttribute("data-player-id");
    let videoId = element.getAttribute("data-id");
    socket.connect();
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket);
    });
  },
  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container");
    let msgInput = document.getElementById("msg-input");
    let postButton = document.getElementById("msg-submit");
    let userList = document.getElementById("user-list");
    let vidChannel = socket.channel("videos:" + videoId, () => {
      return { last_seen_id: lastSeenId };
    });
    let presence = new Presence(vidChannel);
    presence.onSync(() => {
      userList.innerHTML = presence
        .list((id, { user, metas: [first, ...rest] }) => {
          let count = rest.length + 1;
          return `<li>${user.username}: (${count})</li>`;
        })
        .join("");
    });

    postButton.addEventListener("click", () => {
      let payload = { body: msgInput.value, at: Player.getCurrentTime() };
      vidChannel
        .push("new_annotation", payload)
        .receive("error", (e) => console.log(e));
      msgInput.value = "";
    });
    vidChannel.on("new_annotation", (annotation) => {
      lastSeenId = annotation.id;
      this.renderAnnotation(msgContainer, annotation);
    });
    msgContainer.addEventListener("click", (e) => {
      e.preventDefault();
      let seconds =
        e.target.getAttribute("data-seek") ||
        e.target.parentNode.getAttribute("data-seek");
      if (!seconds) {
        return;
      }
      Player.seekTo(seconds);
    });
    vidChannel
      .join()
      .receive("ok", ({ annotations }) => {
        let ids = annotations.map((ann) => ann.id);
        if (ids.length > 0) {
          lastSeenId = Math.max(...ids);
        }
        this.scheduleMessages(msgContainer, annotations);
      })
      .receive("error", (reason) => console.log("join failed", reason));
  },
  renderAnnotation(msgContainer, { user, body, at }) {
    let msg = document.createElement("div");
    msg.innerHTML = `
      <a href="#" data-seek="${esc(at)}"> 
      [${formatTime(at)}]
        <b>${esc(user.username)}</b>: ${esc(body)}
      </a>
    `;
    msgContainer.appendChild(msg);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },
  scheduleMessages(msgContainer, annotations) {
    clearTimeout(this.scheduleTimer);
    this.schedulerTimer = setTimeout(() => {
      let ctime = Player.getCurrentTime();
      let remaining = this.renderAtTime(annotations, ctime, msgContainer);
      this.scheduleMessages(msgContainer, remaining);
    }, 1000);
  },
  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter((ann) => {
      if (ann.at > seconds) {
        return true;
      } else {
        this.renderAnnotation(msgContainer, ann);
        return false;
      }
    });
  },
};

export default Video;
