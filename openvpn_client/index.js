var statuses = ""
var colour_ok = "#43a047"
var colour_nok = "#db4437"
var colour_white = "#ffffff"

// Parse the output from cgi-bin/status.sh
function reqListener() {
  statuses = this.responseText;
  const status = statuses.split("\n");
  // .ovpn file
  if (status[0].endsWith("YES")) {
    document.getElementById("ovpn-status").innerHTML = uploaded;
    document.getElementById("ovpn-status").style.backgroundColor = colour_ok;
    document.getElementById("ovpn-status").style.color = colour_white;
    document.getElementById("ovpn-download").style.display = "inline-block";
  } else {
    document.getElementById("ovpn-status").innerHTML = missing;
    document.getElementById("ovpn-status").style.backgroundColor = colour_nok;
    document.getElementById("ovpn-status").style.color = colour_white;
    document.getElementById("ovpn-download").style.display = "none";
  }
  // .text file
  if (status[1].endsWith("YES")) {
    document.getElementById("text-status").innerHTML = uploaded;
    document.getElementById("text-status").style.backgroundColor = colour_ok;
    document.getElementById("text-status").style.color = colour_white;
    document.getElementById("text-download").style.display = "inline-block";
  } else {
    document.getElementById("text-status").innerHTML = missing;
    document.getElementById("text-status").style.backgroundColor = colour_nok;
    document.getElementById("text-status").style.color = colour_white;
    document.getElementById("text-download").style.display = "none";
  }
  // .pid file
  if (status[2].startsWith("pid=")) {
    document.getElementById("process-status").innerHTML = running;
    document.getElementById("process-status").style.backgroundColor = colour_ok;
    document.getElementById("process-status").style.color = colour_white;
  } else {
    document.getElementById("process-status").innerHTML = stopped;
    document.getElementById("process-status").style.backgroundColor = colour_nok;
    document.getElementById("process-status").style.color = colour_white;
  }
}

// When we move over a button
function buttonHover (element) {
  document.getElementById(element).style.backgroundColor = "#016194";
}

// When we move out from a button
function buttonOut (element) {
  document.getElementById(element).style.backgroundColor = "#009ac7";
}

// Text for statuses by language
if (document.getElementById("index-cs")) {
    var uploaded="Nahrán"
    var missing="Chybějící"
    var running="Běží"
    var stopped="Neběží"
} else {
    var uploaded="Uploaded"
    var missing="Missing"
    var running="Running"
    var stopped="Not running"
}

// Get the statuses using a listener
var req = new XMLHttpRequest();
req.open("GET", "./cgi-bin/status.sh");
req.send();
req.addEventListener("load", reqListener);
