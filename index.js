const express = require("express");
const fs = require("fs");
const sharp = require("sharp");
const {Client} = require("pg");
const ejs = require("ejs");
const sass = require("sass");
const formidable = require("formidable");
const crypto = require("crypto");
const session = require("session");
app = express();

var client = new Client({database: "Ths Shot Line", user:"dimi999", password:"dimi999", host:"localhost", port:5432});
client.connect();

app.set("view engine", "ejs");

app.use("/Resurse", express.static(__dirname + "/Resurse"))

app.get(["/", "/home", "/index"], function(req, res){
    client.query("SELECT * FROM model", function(err, rez) {
        res.render(__dirname + "/Resurse/views/pagini/index.ejs", {ip: req.ip, vector: [5, 7, 9, 12], matrice: [[1, 2, 3], [4, 5, 6], [7, 8, 9]], imagini: obImagini.imagini, produse: rez.rows});
    });
})

app.get("/store", function(req, res) {

    client.query("select * from unnest(enum_range(null::tipuri_produse))", function(err, rezCateg){
        client.query("select * from unnest(enum_range(null::categ_basket))", function(err, rezCategg){
            client.query("SELECT * FROM produse", function(err, resQuery) {
                console.log(err);
                console.log(rezCateg.rows);
                res.render(__dirname + "/Resurse/views/pagini/produse.ejs", {produse: resQuery.rows, optiuni:rezCateg.rows, optiuniMult: rezCategg.rows});
            })
        })
    })


}) 

app.get("/produs/:id", function(req, res) {
    client.query(`SELECT * FROM produse where id=${req.params.id}`, function(err, resQuery) {
        console.log(err);
        res.render(__dirname + "/Resurse/views/pagini/produs.ejs", {prod: resQuery.rows[0]});
    })
}) 

function randeazaEroare(res, identificator, titlu, text, imagine) {
    varErr = obErori.erori.find(function(elem) {
        console.log(elem.identificator)
        return (elem.identificator == identificator);
    })
    console.log(obErori)
    console.log(varErr)
    titlu = titlu || (varErr && varErr.titlu) || "Titlu custom"
    text = text || (varErr && varErr.text) || "Text custom"
    imagine = imagine || (varErr && (obErori.cale_baza + "/" + varErr.imagine)) || "Imagine custom"

    if(varErr && varErr.status)
        res.status(varErr.identificator)
    res.render(__dirname + "/Resurse/views/pagini/eroare_generala", {titlu: titlu, text: text, imagine: imagine});
}


app.get("/eroare", function(req, res){
    randeazaEroare(res,1);
});


parolaServer = "Tehnici"
app.post("/reg", function(req, res) {
    var formular = new formidable.IncomingForm()
    formular.parse(req, function(err, campuriTxt, campuriFile) {
    var parolaCriptata=crypto.scryptSync(campuriTxt.parola, parolaServer, 64).toString("hex");
    var comandaInserare = `insert into utilizatori (username, nume, prenume, parola, email, culoare_chat) values ('${campuriTxt.username}',
    '${campuriTxt.nume}', '${campuriTxt.prenume}', '${parolaCriptata}', '${campuriTxt.email}', '${campuriTxt.culoare_chat}')`;
    client.query(comandaInserare, function(err, rezInsert) {
        if(err)
            console.log(err);
    });
    res.send("OK");
    });

})


app.get("/*.ejs", function(req, res) {
    randeazaEroare(res, 403);
});


app.get("*/galerie_animata.css", function(req, res) {
    var buf=fs.readFileSync(__dirname+"/Resurse/scss/galerie_animata.scss").toString("utf8");
    var rezCss = ejs.render(buf, {nr_imag:nr_imag});
    fs.writeFileSync(__dirname+"/temp/galerie_animata.scss", rezCss);
    try {
        varrez = sass.compile(__dirname+"/temp/galerie_animata.scss", {sourceMap: true});
    }
    catch (err) {
        console.log(err);
    }
    console.log(varrez);

    fs.writeFileSync(__dirname+"/temp/galerie_animata.css", varrez.css);
    res.setHeader("Content-type", "text/css");
    res.sendFile(__dirname+"/temp/galerie_animata.css");
});


app.get("*/galerie_animata.css.map", function(req, res) {
    res.sendFile(__dirname + "/temp/galerie_animata.css.map");
});


app.get("/*", function(req, res) {
    list = obImagini.imagini
    nr_imag = [2, 3, 4]

    nr_imag = nr_imag.sort(() => Math.random() - 0.5)
    nr_imag = nr_imag[0];

    list = list.sort(() => Math.random() - 0.5)
    list = list.slice(0, nr_imag * nr_imag)

    res.render(__dirname + "/Resurse/views/pagini" + req.url, {ip: req.ip, imagini:obImagini.imagini, animate: list}, function(err, rezRand) {
        if(err) {
            randeazaEroare(res, 404);
        }
        else {
            res.send(rezRand);
        }
    });
})


function creeazaImagini(){
    var buf=fs.readFileSync(__dirname+"/Resurse/json/galerie.json").toString("utf8");
    obImagini=JSON.parse(buf);
   
    for (let imag of obImagini.imagini){
        let nume_imag, extensie;
        [nume_imag, extensie ]=imag.cale_imagine.split(".")
        let dim_mic=150
        
        imag.mic=`${obImagini.cale_galerie}/mic/${nume_imag}-${dim_mic}.webp` 
        imag.mare=`${obImagini.cale_galerie}/${imag.cale_imagine}`;
        if (!fs.existsSync(imag.mic))
        sharp(__dirname+"/"+imag.mare).resize(dim_mic).toFile(__dirname+"/"+imag.mic);
        
        let dim_mediu = 300
        imag.mediu = `${obImagini.cale_galerie}/mediu/${nume_imag}-${dim_mediu}.webp`
        if (!fs.existsSync(imag.mediu))
        sharp(__dirname+"/"+imag.mare).resize(dim_mediu).toFile(__dirname+"/"+imag.mediu);
    }
}
creeazaImagini();

function creeazaErori(){
    var buf=fs.readFileSync(__dirname+"/Resurse/json/erori.json").toString("utf8");
    obErori=JSON.parse(buf);
}
creeazaErori();

//app.listen(8080);
var s_port=process.env.PORT || 8080;
app.listen(s_port);
console.log("Am pornit");



