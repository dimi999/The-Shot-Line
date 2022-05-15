window.addEventListener("load", function() {

    document.getElementById("btn_tema").onclick = function() {
        var tema = localStorage.getItem("tema");
        if(tema)
            localStorage.removeItem("tema");
        else
            localStorage.setItem("tema", "dark");
        
            document.body.classList.toggle("dark");
        if(document.getElementById("btn_tema").innerHTML != '<i class="fa-solid fa-moon"></i>')
            document.getElementById("btn_tema").innerHTML = '<i class="fa-solid fa-moon"></i>' 
        else
        document.getElementById("btn_tema").innerHTML = '<i class="fa-solid fa-sun"></i>';
    }
})