const express = require("express");
const fs = require("fs");
const sharp = require("sharp");
const {Client} = require("pg");
const ejs = require("ejs");
const sass = require("sass");
const formidable = require("formidable");
const crypto = require("crypto");
const url = require('url');
const session = require("express-session");
const nodemailer = require("nodemailer");
app = express();

if(process.env.SITE_ONLINE) {
    var client = new Client({database: "dbsgrmc511n47u", user:"aatjsoegekxwao",
    password:"c6dc9eb03628e72df499fc01c777c48ff4b11318a12daff042e63867573f4c30",
    host:"ec2-54-157-79-121.compute-1.amazonaws.com", port:5432,
    ssl: {
        rejectUnauthorized: false
    }
    });
    obGlobal.protocol = "https://"
    obGlobal.domeniu = "theshotline.herokuapp.com"
}
else {
    var client = new Client({database: "Ths Shot Line", user:"dimi999", password:"dimi999", host:"localhost", port:5432});
    obGlobal.protocol = "http://"
    obGlobal.domeniu = "localhost:8080"
}


client.connect();


async function trimiteMail(email, subiect, mesajText, mesajHtml, atasamente=[]){
    var transp= nodemailer.createTransport({
        service: "gmail",
        secure: false,
        auth:{//date login 
            user:obGlobal.emailServer,
            pass:"ymimltpbvdcnmwab"
        },
        tls:{
            rejectUnauthorized:false
        }
    });
    //genereaza html
    await transp.sendMail({
        from:obGlobal.emailServer,
        to:email,
        subject:subiect,//"Te-ai inregistrat cu succes",
        text:mesajText, //"Username-ul tau este "+username
        html: mesajHtml,// ,
        attachments: atasamente
    })
    console.log("trimis mail");
}

const obGlobal={
    obImagini:null,
    obErori:null,
    emailServer: "theshotline@gmail.com",
    protocol: null,
    domeniu: null
}


app.use(session({
    secret: 'abcdefg',//folosit de express session pentru criptarea id-ului de sesiune
    resave: true,
    saveUninitialized: false
  }));

app.set("view engine", "ejs");

app.use("/Resurse", express.static(__dirname + "/Resurse"))

function getIp(req){//pentru Heroku
    var ip = req.headers["x-forwarded-for"];//ip-ul userului pentru care este forwardat mesajul
    if (ip){
        let vect=ip.split(",");
        return vect[vect.length-1];
    }
    else if (req.ip){
        return req.ip;
    }
    else{
     return req.connection.remoteAddress;
    }
}

function stergeAccesVechi() {
    var queryDelete = "DELETE FROM accesari WHERE now() - data_accesare >= interval '5 minutes'"
    client.query(queryDelete, function(err, res) {
        console.log(err);
    })
}

app.use("/*", function(req, res, next) {
    res.locals.categs=categorii;
    res.locals.utilizator = req.session.utilizator;
    next();
})

app.get("/*", function(req, res, next) {
    // let queryIns = `insert into accesari(ip, user_id, pagina) values ('${req.ip}', '${req.session.utilizator.id}', '${req.url}')`
    next()
})

app.get(["/", "/home", "/index"], function(req, res){
    client.query("SELECT * FROM model", function(err, rez) {
        res.render(__dirname + "/Resurse/views/pagini/index.ejs", {ip: req.ip, vector: [5, 7, 9, 12],
             matrice: [[1, 2, 3], [4, 5, 6], [7, 8, 9]], imagini: obImagini.imagini, produse: rez.rows});
    });

    var querySelect = "SELECT username, nume FROM utilizatori WHERE id IN (SELECT distinct user_id FROM accesari where now() - data_accesare <= interval('5 minutes'))"
    client.query(querySelect, function(err, rezQ) {
        useriOn = []
        if(err) console.log(err)
        else useriOn = rezQ.rows;
        // res.render()
    })
})

app.get("/logout", function(req, res) {
    req.session.destroy();
    res.redirect("/index");
})

app.get("/store", function(req, res) {
    const params = url.parse(req.url, true).query;
    client.query("select * from unnest(enum_range(null::tipuri_produse))", function(err, rezCateg){
        client.query("select * from unnest(enum_range(null::categ_basket))", function(err, rezCategg){
            if(params['type'] == undefined) {
                client.query("SELECT * FROM produse", function(err, resQuery) {
                    console.log(err);
                    console.log(resQuery.rows[0])
                    res.render(__dirname + "/Resurse/views/pagini/produse.ejs", {produse: resQuery.rows, optiuni:rezCateg.rows,
                        optiuniMult: rezCategg.rows});
                })
            }
            else {
                client.query(`SELECT * FROM produse where tip_produs = '${params['type']}'`, function(err, resQuery) {
                    console.log(err);
                    res.render(__dirname + "/Resurse/views/pagini/produse.ejs", {produse: resQuery.rows, optiuni:rezCateg.rows,
                        optiuniMult: rezCategg.rows});
                })
            }
        })
    })
}) 

app.get("/useri", function(req, res){
    if(req.session.utilizator && req.session.utilizator.rol == "admin")
    client.query("select * from utilizatori", function(err, rezQ) {
        console.log(err);
        res.render("pagini/useri", {useri: rezQ.rows})
    })
    else {
        randeazaEroare(res, 403);
    }
})

app.post("/sterge_utiliz", function(req,res) {

})

app.get("/produs/:id", function(req, res) {
    client.query(`SELECT * FROM produse where id=${req.params.id}`, function(err, resQuery) {
        console.log(err);
        res.render(__dirname + "/Resurse/views/pagini/produs.ejs", {prod: resQuery.rows[0]});
    })
}) 

function randeazaEroare(res, identificator, titlu, text, imagine) {
    varErr = obErori.erori.find(function(elem) {
        return (elem.identificator == identificator);
    })
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
    
    var eror = "";
    if(campuriTxt.username == "") {
        eror += "Username necompletat! ";
    }

    if(campuriTxt.parola == "") {
        eror += "Parola necompletata! ";
    }
    
    if(campuriTxt.rparola == "") {
        eror += "Reintroduceti parola pentru validare! ";
    }

    if(campuriTxt.email == "") {
        eror += "Email necompletat! ";
    }

    if(!campuriTxt.username.match(new RegExp("^[A-Za-z0-9]+$"))) {
        eror += "Username poate contine doar litere si cifre! ";
    }
    if(!campuriTxt.nume.match(new RegExp("^[A-Za-z]*$"))) {
        eror += "Numele poate contine doar litere! ";
    }
    if(!campuriTxt.prenume.match(new RegExp("^[A-Za-z]*$"))) {
        eror += "Preumele poate contine doar litere! ";
    }
    if(campuriTxt.parola.includes("'") || campuriTxt.parola.includes('"') || campuriTxt.parola.includes("<") || campuriTxt.parola.includes(">")) {
        eror += "Parola nu poate contine <, >, ', \"! ";
    }
    console.log(campuriTxt.parola);
    if(campuriTxt.parola != campuriTxt.rparola) {
        eror += `Parole diferite! ${campuriTxt.parola} ${campuriTxt.rparola}`
    }
    var culori = ["red", "black", "green", "blue"];
    console.log(campuriTxt.culoare_chat);
    if(!culori.includes(campuriTxt.culoare_chat)) {
        eror += "Culoare invalida! "
    }
    if(!campuriTxt.email.match(new RegExp("^[A-Za-z0-9-_.]+@[A-Za-z0-9]+.[A-Za-z]{2,3}$"))) {
        eror += "Preumele poate contine doar litere! ";
    }
    var queryutiliz = `SELECT username FROM utilizatori where username = '${campuriTxt.username}'`;
    client.query(queryutiliz, function(err, rezQ) {
        if(rezQ.rows.length != 0)
            eror += "Username deja folosit! " 
    })
    
    // var queryemail = `SELECT email FROM utilizatori where email = '${campuriTxt.email}'`;
    // client.query(queryemail, function(err, rezQ) {
    //     if(rezQ.rows.length != 0)
    //         eror += "Email deja folosit! " 
    // })

    if(eror == "") {
        var token = genereazaToken(campuriTxt.username);
        var comandaInserare = `insert into utilizatori (username, nume, prenume, parola, email, culoare_chat, cod) values ('${campuriTxt.username}',
        '${campuriTxt.nume}', '${campuriTxt.prenume}', '${parolaCriptata}', '${campuriTxt.email}', '${campuriTxt.culoare_chat}', '${token[0] + token[1]}')`;
        client.query(comandaInserare, function(err, rezInsert) {
            if(err)
                console.log(err);
        });
        
        var linkconfirmare = `${obGlobal.protocol + obGlobal.domeniu}/confirm_reg/${token[0]}/${campuriTxt.username}/${token[1]}`

        res.render(__dirname + "/Resurse/views/pagini/register", {raspuns: "Ati fost inregistrat cu succes. Verificati email-ul pentru valdiare"});
        trimiteMail(campuriTxt.email, "Registration TheShotLine", "",
         `<h1 style='background-color:aqua'>Bine ai venit in comunitatea The Shot Line!</h1>
         <p>Username-ul tau este ${campuriTxt.username}. Valideaza-ti contul apasand pe acest <a href = ${linkconfirmare}>link<a>.`)
    }
    else 
        res.render(__dirname + "/Resurse/views/pagini/register", {eroare: eror});
    });
})

app.get("/confirm_reg/:token1/:user/:token2", function(req, res) {
    var comandaConfirm = `SELECT * FROM utilizatori WHERE username = '${req.params.user}' AND cod = '${req.params.token1 + req.params.token2}'`;
    client.query(comandaConfirm, function(err, rezQ) {
        if(rezQ.rows.length != 0) {
            var comandaUpdate = `UPDATE utilizatori SET confirmat_mail=true WHERE username = '${req.params.user}' AND cod = '${req.params.token1 + req.params.token2}'`;
            client.query(comandaUpdate, function(err, rezQ) {
                console.log(err);
            })
        }
        else randeazaEroare(res, 403);
    })
    res.render(__dirname + "/Resurse/views/pagini/confirmare")
})

const alphabet = "ABCDEFGHIJKLMNOP"

function genereazaToken(nume) {
    var token1 = Math.random().toString().slice(2, 12);
    var token = nume + "-", token2 = "";
    for(let i = token.length; i <= 70; i++) {
        const litera = alphabet[Math.floor(Math.random() * alphabet.length)]
        token2 += litera; 
    }
    return [token1, token + token2]; 
}

app.post("/login",function(req, res){
    console.log("ceva");
    var formular= new formidable.IncomingForm()
    formular.parse(req, function(err, campuriText, campuriFisier ){
        console.log(campuriText);
        var parolaCriptata=crypto.scryptSync(campuriText.parola,parolaServer, 64).toString('hex');
        var querySelect=`select * from utilizatori where username='${campuriText.username}' and parola='${parolaCriptata}' and confirmat_mail = true`;
        console.log(querySelect);
        client.query(querySelect,function(err, rezSelect){
            if(err)
                console.log(err);
            else{
                console.log(rezSelect.rows.length);
                if(rezSelect.rows.length==1){ //daca am utilizatorul si a dat credentiale corecte
                    req.session.utilizator={
                        nume:rezSelect.rows[0].nume,
                        prenume:rezSelect.rows[0].prenume,                        
                        username:rezSelect.rows[0].username,                        
                        email:rezSelect.rows[0].email,
                        culoare_chat:rezSelect.rows[0].culoare_chat,                        
                        rol:rezSelect.rows[0].rol
                    }
                    res.redirect("/index");
                }
                else randeazaEroare(res, -1, "Login esuat", "User sau parola gresita sau mail neconfirmat!");
            }
        } )
    })
});


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

 
app.post("/profil", function(req, res){
    console.log("profil");
    if (!req.session.utilizator){
        res.render("pagini/eroare_generala",{text:"Nu sunteti logat."});
        return;
    }
    var formular= new formidable.IncomingForm();
 
    formular.parse(req,function(err, campuriText, campuriFile){
       
        var criptareParola=crypto.scryptSync(campuriText.parola,parolaServer, 64).toString('hex');
 
        //TO DO query
        var queryUpdate=`UPDATE utilizatori SET nume='${campuriText.nume}',
                                                prenume='${campuriText.prenume}',
                                                email='${campuriText.email}',
                                                culoare_chat='${campuriText.culoare_chat}'
                                                WHERE parola='${criptareParola}'`;
       
        client.query(queryUpdate,  function(err, rez){
            if(err){
                console.log(err);
                res.render("pagini/eroare_generala",{text:"Eroare baza date. Incercati mai tarziu."});
                return;
            }
            if (rez.rowCount==0){
                res.render("pagini/profil",{mesaj:"Update-ul nu s-a realizat. Verificati parola introdusa."});
                return;
            }
            else {
                req.session.utilizator.nume = campuriText.nume;
                req.session.utilizator.prenume = campuriText.prenume;
                req.session.utilizator.email = campuriText.email;
                req.session.utilizator.culoare_chat = campuriText.culoare_chat;
            }
           
            //TO DO actualizare sesiune
 
            res.render("pagini/profil",{mesaj:"Update-ul s-a realizat cu succes."});
 
        });
       
 
    });
});


var categorii;

function getCategories() {
    client.query("select * from unnest(enum_range(null::tipuri_produse))", function(err, rezCateg){
        categorii = rezCateg.rows;
        console.log(categorii);
    })
}
getCategories();

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

stergeAccesVechi();
setInterval(stergeAccesVechi, 600 * 1000)

//app.listen(8080);
var s_port=process.env.PORT || 8080;
app.listen(s_port);
console.log("Am pornit");



