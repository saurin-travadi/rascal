function getVIN(document_root) {

    showStat(data.TotalReserved, data.TotalReserved - data.TotalRemining);
    $('#VIN').val(data.VIN);
    $('#VIN').attr('extValAdded', '1');
    $('#VIN').focus();
    return null;
}

function showStat(resCnt, resCom) {

    $('#recall_stat').remove();

    var dd = $('<div id="recall_stat" style="background-color:gray; border:black solid 1px; text-align:center; height:60px; width:200px; position:absolute; left:20px; top:100px;">Status</div>');
    $('#navSection').append(dd);

    var d0 = $('<div style="clear:both" />');
    $(dd).append(d0);

    var d1 = $('<div style="float:left">Your Reserved Count</div><div style="float:right">' + resCnt + '</span></div>');
    $(dd).append(d1);

    var d2 = $('<div style="clear:both" />');
    $(dd).append(d2);

    var d3 = $('<div style="float:left">Your Count Complete</div><div style="float:right">' + resCom + '</span></div>');
    $(dd).append(d3);

}

chrome.runtime.sendMessage({
    action: "getVIN",
    source: getVIN(document)
});