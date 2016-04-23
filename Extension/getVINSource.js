function getVIN(document_root) {
    
    //$('.recaptcha-checkbox-checkmark').attr('checked',true);
    $('#VIN').focus();
}

chrome.runtime.sendMessage({
    action: "getVIN",
    source: getVIN(document)
});