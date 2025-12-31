var statuses = ""

function reqListener() {
  statuses = this.responseText;
  const status = statuses.split("\n");
  // .ovpn file
  if (status[0].endsWith("YES")) {
    document.getElementById("ovpn-status").innerHTML = "Uploaded";
    document.getElementById("ovpn-status").style.backgroundColor = "#88ff88";
    document.getElementById("ovpn-download").style.display = "inline-block";
  } else {
    document.getElementById("ovpn-status").innerHTML = "Missing";
    document.getElementById("ovpn-status").style.backgroundColor = "#ff8888";
    document.getElementById("ovpn-download").style.display = "none";
  }
  // .text file
  if (status[1].endsWith("YES")) {
    document.getElementById("text-status").innerHTML = "Uploaded";
    document.getElementById("text-status").style.backgroundColor = "#88ff88";
    document.getElementById("text-download").style.display = "inline-block";
  } else {
    document.getElementById("text-status").innerHTML = "Missing";
    document.getElementById("text-status").style.backgroundColor = "#ff8888";
    document.getElementById("text-download").style.display = "none";
  }
  // .pid file
  if (status[2].endsWith("=0")) {
    document.getElementById("process-status").innerHTML = "Not running";
    document.getElementById("process-status").style.backgroundColor = "#ff8888";
  } else {
    document.getElementById("process-status").innerHTML = "Running";
    document.getElementById("process-status").style.backgroundColor = "#88ff88";
  }
}

function buttonHover (element) {
  document.getElementById(element).style.backgroundColor = "#016194";
}

function buttonOut (element) {
  document.getElementById(element).style.backgroundColor = "#009ac7";
}

var req = new XMLHttpRequest();
req.open("GET", "./cgi-bin/status.sh");
req.send();
req.addEventListener("load", reqListener);
