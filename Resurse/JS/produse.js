window.addEventListener("load", function() {
    
    document.getElementById("inp-pret").onchange = function() {
        document.getElementById("infoRange").innerHTML = "(" + this.value + ")";
    }


    document.getElementById("filtrare").onclick = function() {

        if(document.getElementById("inp-cuv").value.toLowerCase().includes(" "))
            alert("Lista de cuvite nu poate contine spatii. Separarea se face prin ,")


        var valNume = document.getElementById("inp-nume").value.toLowerCase();
        var valCuv = document.getElementById("inp-cuv").value.toLowerCase().split(",");
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

        var listMaterials = [];
        var btncheck = document.getElementsByName("gr_chk");
        for(let rad of btncheck) {
            if(rad.checked) {
                listMaterials.push(rad.value);
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

        var copii = document.getElementById("ptcopii").value || "Toate";


        var valPret = document.getElementById("inp-pret").value;
        for(let art of articole) {
            art.style.display = "none";
            let descr = art.getElementsByClassName("val-descr")[0].innerHTML.toLowerCase();
            let cond1 = false;
            for(let cuv of valCuv) {
                if(descr.includes(cuv)) {
                    cond1 = true;
                    break;
                }
            }

            let marime = parseInt(art.getElementsByClassName("val-marime")[0].innerHTML);
            let cond2 = (marime >= minmarime && marime < maxmarime);

            let pretArt = parseInt(art.getElementsByClassName("val-pret")[0].innerHTML)
            let cond3 = (pretArt >= valPret);
            
            let tipArt = art.getElementsByClassName("val-tip")[0].innerHTML;
            let cond4 = (tipArt == tip || tip == "toate");

            let categArt = art.getElementsByClassName("val-categorie")[0].innerHTML;
            let cond5 = (categ.includes(categArt) || categ.includes("toate"));

            let materialArt = art.getElementsByClassName("val-materiale")[0].innerHTML.toLowerCase().split(',');
            let cond6 = false;
            for(material of materialArt)
                if(listMaterials.includes(material) || listMaterials.includes("toate")) {
                    cond6 = true;
                    break;
                }
            
            let numeArt = art.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase(); 
            let cond7 = numeArt.startsWith(valNume);

            let ptcopii = art.getElementsByClassName("val-kids")[0].innerHTML.toString();
            let cond8 = (ptcopii == copii || copii == "Toate")
            console.log(ptcopii, copii);

            let condititeFinal = cond1 && cond2 && cond3 && cond4 && cond5 && cond6 && cond7 && cond8;
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
            document.getElementById("inp-cuv").value = "";
            document.getElementById("i_rad4").checked = true;
            document.getElementById("inp-pret").value = 0;
            document.getElementById("infoRange").innerHTML = "(0)";

            var btncheck = document.getElementsByName("gr_chk");
            for(let rad of btncheck) {
                if(rad.value == "toate") {
                    rad.checked = true;
                    continue;
                }
                rad.checked = false;
            }

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
           if(parseFloat(a.getElementsByClassName("val-pret")[0].innerHTML) - parseFloat(b.getElementsByClassName("val-pret")[0].innerHTML) == 0)
                return a.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase().localeCompare(b.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase());
            return parseFloat(a.getElementsByClassName("val-pret")[0].innerHTML) - parseFloat(b.getElementsByClassName("val-pret")[0].innerHTML);
        });
        for(let art of v_articole) {
            art.parentElement.appendChild(art);
        }
    }

    document.getElementById("sortDescrescNume").onclick = function() {
        var articole = document.getElementsByClassName("produs");
        var v_articole = Array.from(articole);
        v_articole.sort(function(a, b) {
           if(parseFloat(b.getElementsByClassName("val-pret")[0].innerHTML) - parseFloat(a.getElementsByClassName("val-pret")[0].innerHTML) == 0)
                return a.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase().localeCompare(b.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase());
            return parseFloat(b.getElementsByClassName("val-pret")[0].innerHTML) - parseFloat(a.getElementsByClassName("val-pret")[0].innerHTML);
        });
        for(let art of v_articole) {
            art.parentElement.appendChild(art);
        }
    }

    document.getElementById("calculate").onclick = function() {
        var articole = document.getElementsByClassName("produs");
        var sum = 0
        for(let art of articole) {
            if(art.style.display != "none") {
                sum += parseFloat(art.getElementsByClassName("val-pret")[0].innerHTML)
            }
        }
        var exists_p = document.getElementById("suma_calc");
        if(!exists_p) {
            var p_new = document.createElement("p");
            p_new.innerHTML = `<b>Suma produselor afisate este:<b> ${sum}`;
            p_new.id = "suma_calc";
            var section = document.getElementById("calculate");
            section.parentNode.insertBefore(p_new, section);
            setTimeout(function() {
                var p_sters = document.getElementById("suma_calc");
                p_sters.remove();
            }, 2000)
        }
    }
})