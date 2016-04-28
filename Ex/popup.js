chrome.runtime.onMessage.addListener(function (request, sender) {
    if (request.action == "getSource") {
        postData(request.source,'post');
    }
});

chrome.browserAction.onClicked.addListener(function (tab) {
    onWindowLoad();
});


var baseURL = "http://ec2-54-85-96-2.compute-1.amazonaws.com/";
var serviceURL = baseURL + "GetVin.aspx";


function onWindowLoad() {

    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
        if (tabs[0].url.indexOf('vinrcl.safercar.gov') < 0)
            chrome.tabs.update(tabs[0].id, { url: "http://vinrcl.safercar.gov" });
    });

    var user = readCookie('username');
    if (user == null) {
        var user = prompt("Please enter your name", "");
        if (user != null) {
            createCookie('username', user, 900);
        }
    }

    if(user!=null)
        onReadRecall();
}


function onReadRecall() {

    chrome.tabs.executeScript(null, {
        file: "jquery-2.2.3.js"
    }, function () {
        if (chrome.runtime.lastError) {
            alert('There was an error injecting jquery : \n' + chrome.runtime.lastError.message);
        }
        else {
            chrome.tabs.executeScript(null, {
                file: "getPagesSource.js"
            }, function () {
                if (chrome.runtime.lastError) {
                    alert('There was an error injecting script : \n' + chrome.runtime.lastError.message);
                }
            });
        }
    });
}

function postData(userData, action) {

    var user = readCookie('username');

    if (userData == null)
        userData = { user: user, vin: '', data: '' };
    else {
        userData = { user: user, vin: userData.split(':')[0], data: userData.split(':')[1] };
    }

    $.ajax({
        type: "POST",
        url: serviceURL,
        data: userData,
        success: function (data) {
            chrome.tabs.executeScript({
                code: 'document.getElementById("VIN").value = "' + data.VIN + '"'
            });
            chrome.tabs.executeScript(null, {
                file: "getVINSource.js"
            }, null);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert('There was an error injecting jquery : \n' + chrome.runtime.lastError.message);
        }
    });
}

function createCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    }
    else var expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name, "", -1);
}
