window.addEventListener("load", function() {
    
    document.getElementById("inp-pret").onchange = function() {
        document.getElementById("infoRange").innerHTML = "(" + this.value + ")";
    }


    document.getElementById("filtrare").onclick = function() {
        var valNume = document.getElementById("inp-nume").value.toLowerCase();
        var articole = document.getElementsByClassName("produs");

        var selsimplu = document.getElementsByClassName("sel-simplu");
        var selmul = document.getElementsByClassName("sel-mult");
        var tip; const categ = [];

        for(let crt of selsimplu) {
            if(crt.selected) {
                tip = crt.value;
                break;
            }
        }

        for(let crt of selmul) {
            if(crt.selected) {
                categ.push(crt.value);
            }
        }

        
        var btnradio = document.getElementsByName("gr_rad");
        for(let rad of btnradio) {
            if(rad.checked) {
                var valMarime = rad.value;
                break;
            }
        }

        var minmarime, maxmarime;

        if(valMarime != "toate") {
            [minmarime, maxmarime] = valMarime.split(":");
            minmarime = parseInt(minmarime);
            maxmarime = parseInt(maxmarime);
        }
        else {
            minmarime = 0;
            maxmarime = 10000000;
        }


        var valPret = document.getElementById("inp-pret").value;
        for(let art of articole) {
            art.style.display = "none";
            let nume = art.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase();
            let cond1 = nume.startsWith(valNume);

            let marime = parseInt(art.getElementsByClassName("val-marime")[0].innerHTML);
            let cond2 = (marime >= minmarime && marime < maxmarime);

            let pretArt = parseInt(art.getElementsByClassName("val-pret")[0].innerHTML)
            let cond3 = (pretArt >= valPret);
            
            let tipArt = art.getElementsByClassName("val-tip")[0].innerHTML;
            let cond4 = (tipArt == tip || tip == "toate");

            let categArt = art.getElementsByClassName("val-categorie")[0].innerHTML;
            let cond5 = (categ.includes(categArt) || categ.includes("toate"));
            
            // console.log(cond1, cond2, cond3, cond4, cond5);

            let condititeFinal = cond1 && cond2 && cond3 && cond4 && cond5;
            if(condititeFinal)
                art.style.display = "block"; 
        }
    }

    document.getElementById("resetare").onclick = function() {
        var articole = document.getElementsByClassName("produs");
        var selsimplu = document.getElementsByClassName("sel-simplu");
        var selmul = document.getElementsByClassName("sel-mult");
        for(let art of articole)
            art.style.display = "block";
        
            document.getElementById("inp-nume").value = "";
            document.getElementById("i_rad4").checked = true;
            document.getElementById("inp-pret").value = 0;
            document.getElementById("infoRange").innerHTML = "(0)";

            for(let crt of selsimplu) {
                if(crt.value != "toate")
                    crt.selected = false;
                else
                    crt.selcted = true;
            }

            for(let crt of selmul) {
                if(crt.value != "toate")
                    crt.selected = false;
                else {
                    crt.selected = true;
                }
            }
    }

    document.getElementById("sortCrescNume").onclick = function() {
        var articole = document.getElementsByClassName("produs");
        var v_articole = Array.from(articole);
        v_articole.sort(function(a, b) {
           return parseFloat(a.getElementsByClassName("val-pret")[0].innerHTML) - parseFloat(b.getElementsByClassName("val-pret")[0].innerHTML); 
        });
        for(let art of v_articole) {
            art.parentElement.appendChild(art);
        }
    }

    window.onkeydown=function(event) {
    }
})