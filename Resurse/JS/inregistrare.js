window.onload = function() {
    var formular = document.getElementById("form_inreg");
    if(formular) {
        formular.onsubmit = function() {
            console.log(document.getElementById("parl").value, document.getElementById("rparl").value)
            if(document.getElementById("parl").value != document.getElementById("rparl").value) {
                alert("Parolele sunt diferite!")
                return false;
            }       
            return true;
        }
    }
}