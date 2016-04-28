function getVIN(document_root) {

    document_root.getElementById('VIN').focus();
    return null;
}

chrome.runtime.sendMessage({
    action: "getVIN",
    source: getVIN(document)
});