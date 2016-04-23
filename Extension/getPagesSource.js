function DOMtoString(document_root) {
    var retHtml = '';

    var spans = $(document_root).find("span:contains('NHTSA Recall')");
    spans.each(function () {
        var s = $(this);
        var number = $(s).find('span a').html().replace('\n', '').replace('  ', '');
        retHtml += number + '~';
    });

    retHtml += $('#VIN').val();

    return retHtml;
}

chrome.runtime.sendMessage({
    action: "getSource",
    source: DOMtoString(document)
});