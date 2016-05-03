function DOMtoString(document_root) {
    var retHtml = '';

    if ($('.errorMessages').length > 0) {
        retHtml = $('#VIN').val() + ":";

        $('.errorMessages').remove();
        return retHtml;
    }
    else {
        try {
            var spans = $(document_root).find("span:contains('NHTSA Recall')");
            spans.each(function () {
                var s = $(this);
                var ele = $(s).find('span a');

                var number = '';
                if ($(ele).length>0)
                    number = $(ele).html().replace('\n', '').replace('  ', '');

                retHtml += number + '~';
            });

        } catch (e) {
            retHtml = '';
        }

        //read VIN from context html and not from input
        var ymm = $('.contentbox h2')[0];
        var vin = $($(ymm).find('span')[0]).html();

        var strData = vin + ":" + retHtml.trim();

        $('.contentbox').remove();
        return strData;
    }
}

chrome.runtime.sendMessage({
    action: "getSource",
    source: DOMtoString(document)
});