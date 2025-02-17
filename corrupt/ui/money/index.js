$(document).ready(function(){
    $(".money-hud").hide();
    $("#proximity, #cash-text, #bank-text, #bighudfam").hide();
    window.addEventListener("message", function(event){
        if(event.data.updateMoney == true){
            positionHud(event.data.topLeftAnchor)
            setMoney(event.data.cash,'#cash-text');
            setMoney(event.data.redmoney,'#redmoney-text');
            if (event.data.redmoney == "£0") {
                document.getElementById('redmoney').style.display = "none";
            } else {
                document.getElementById('redmoney').style.display = "block";
            }
            setMoney(event.data.bank,'#bank-text');
            document.getElementById('proximity').innerHTML = event.data.proximity;
            document.getElementById('permid').innerHTML = "Perm ID: " + event.data.userId;
        }
        if(event.data.moneyTalking == true){
            document.getElementById('proximity').style.color = "lightblue";
        } else if (event.data.moneyTalking == false) {
            document.getElementById('proximity').style.color = "white";
        }
        if(event.data.showMoney == false){
            document.getElementById('proximity').style.display = "none";
            document.getElementById('cash-text').style.display = "none";
            document.getElementById('bank-text').style.display = "none";
            document.getElementById('bighudfam').style.display = "none";
        }
        if(event.data.showMoney == true){
            document.getElementById('proximity').style.display = "block";
            document.getElementById('cash-text').style.display = "block";
            document.getElementById('bank-text').style.display = "block";
            document.getElementById('bighudfam').style.display = "block";
        }
    });
    function setMoney(amount, element){
        $(element).text(amount);
    }
    function positionHud(topLeftAnchor){
        $(".money-hud").css("left", topLeftAnchor + "px");
    }
    function updateClock() {
    var now = new Date(),
        time = (now.getHours()<10?'0':'') + now.getHours() + ':' + (now.getMinutes()<10?'0':'') + now.getMinutes();

    document.getElementById('hour').innerHTML = [time];
    setTimeout(updateClock, 1000);
    }
    updateClock();

    $.post("https://corrupt/moneyUILoaded", JSON.stringify({}));
});
