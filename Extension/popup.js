chrome.runtime.onMessage.addListener(function (request, sender) {
    if (request.action == "getSource") {
        alert(request.source);
    }
});

function onWindowLoad() {

    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
        if (tabs[0].url.indexOf('vinrcl.safercar.gov') < 0)
            chrome.tabs.update(tabs[0].id, { url: "http://vinrcl.safercar.gov" });
    });

    var user = readCookie('username');
    if (user == null) {
        setLogin();
    }
    else {
        setLoggedIn();
    }

    document.getElementById('login').addEventListener('click', onLogIn, false);
    document.getElementById('logout').addEventListener('click', onLogOut, false);

    document.getElementById('next').addEventListener('click', onGetNextClick, false);
    document.getElementById('read').addEventListener('click', onReadRecall, false);

}

function onGetNextClick() {

    var user = readCookie('username');
    $.ajax({
        type: "POST",
        url: "http://ec2-54-85-96-2.compute-1.amazonaws.com/GetVin.aspx",
        data: { 'user': user, 'vin': '', 'data': '' },
        success: function (data) {
            $('#TotalRemining').val(data.TotalRemining);
            $('#TotalReserved').val(data.TotalReserved);
            $('#CountComplete').val(data.TotalReserved - data.TotalRemining);

            chrome.tabs.executeScript({
                code: 'document.getElementById("VIN").value = "' + data.VIN + '"'
            });
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert('There was an error injecting jquery : \n' + chrome.runtime.lastError.message);
        }
    });
}

function onLogIn() {
    createCookie('username', $('#txtName').val(), 900);
    setLoggedIn();
}

function onLogOut() {
    eraseCookie('username');
    setLogin();
}

function setLogin() {
    $('#loginDiv').show();
    $('#loggedInDiv').hide();
}

function setLoggedIn() {
    $('#loginDiv').hide();
    $('#loggedInDiv').show();

    $('#user').html(readCookie('username'));
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

readRecall = function (doc) {
    var spans = $(document).find("span:contains('NHTSA Recall')");
    alert(spans);
    spans.each(function () {
        var s = $(this);
        var number = $(s).find('span a').html().replace('\n', '').replace('  ', '');
        alert(number);
    })
};

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

window.onload = onWindowLoad;