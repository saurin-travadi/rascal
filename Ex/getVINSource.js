function getVIN(document_root) {

    showStat(data.TotalReserved, data.TotalReserved - data.TotalRemining, data.Rate);
    $('#VIN').val(data.VIN);
    $('#VIN').attr('extValAdded', '1');
    $('#VIN').focus();
    return null;
}

function showStat(resCnt, resCom, rate) {

    $('#recall_stat').remove();

    var d = $('<div />');
    var html = '<div id="recall_stat" style="background-color:darkgray;border:black solid 1px; text-align:center; height:150px; width:250px; position:absolute; left:20px; top:150px;">';
    html += '<div style="background-color:gray;font-size:20px">Status</div>';
    html += '<div style="clear:both"></div><div style="float:left;font-size:18px;margin:5px;">Your Reserved Count</div>';
    html += '<div style="float:right;font-size:18px;margin:5px;">' + resCnt + '</div><div style="clear:both"></div>';
    html += '<div style="float:left;font-size:18px;margin:5px;">Your Count Complete</div><div style="float:right;font-size:18px;margin:5px;">' + resCom + '</div>';
    html += '<div style="clear:both"></div><div style="float:left;font-size:18px;margin:5px;">Speed(Last 10 Mins)</div>';
    html += '<div style="float:right;font-size:18px;margin:5px;">' + rate + '</div><div style="clear:both"></div>';
    html += '</div>';
    $(d).html(html)

    $('#navSection').append(d);
}

chrome.runtime.sendMessage({
    action: "getVIN",
    source: getVIN(document)
});