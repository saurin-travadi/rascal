function DOMtoString(document_root) {
    var retHtml = '';

    var spans = $(document_root).find("span:contains('NHTSA Recall')");
    spans.each(function () {
        var s = $(this);
        var number = $(s).find('span a').html().replace('\n', '').replace('  ', '');
        retHtml += number + '~';
    });

    //read VIN from context html and not from input
    var ymm = $('.contentbox h2')[0];
    var vin = $($(ymm).find('span')[0]).html();

    var strData = vin + ":" + retHtml;
    return strData;
}

chrome.runtime.sendMessage({
    action: "getSource",
    source: DOMtoString(document)
});