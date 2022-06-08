window.onload = function() {
    var formular = document.getElementById("form_recover");
    if(formular) {
        formular.onsubmit = function() {
            console.log(document.getElementById("parl").value, document.getElementById("parl-cpy").value)
            if(document.getElementById("parl").value != document.getElementById("parl-cpy").value) {
                alert("Parolele sunt diferite!")
                return false;
            }       
            return true;
        }
    }
}