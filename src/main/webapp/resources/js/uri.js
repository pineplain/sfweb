var KASHIWADE_BASE_URL = "http://heineken.is.k.u-tokyo.ac.jp/forest3/";

var prefixes = new Object();
prefixes ["dc"] = "http://purl.org/dc/elements/1.1/";
prefixes ["rdf"]= "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
prefixes ["rdfs"]  = "http://www.w3.org/2000/01/rdf-schema#";
prefixes ["kd"] = "http://kashiwade.org/2012/09/kd#";
prefixes["kdclass"] = "http://kashiwade.org/2012/09/kd/class/";
prefixes["kdinstance"] = "http://kashiwade.org/2012/09/kd/entity/";
prefixes["sf"] = "http://sfweb.is.k.u-tokyo.ac.jp/";

function arrangePrefix(data){
    $.each(prefixes , function(key, value) {
        data = data.replace(value, key+":");
    })
    return data;
}

function rearrangePrefix(data){
    var str = data.split(":");
    //console.log(str);
    return prefixes[str[0]] + str[1];
}

function getPrefixes(){
    var prefix = "";
    $.each(prefixes , function(key, value) {
        prefix += " PREFIX "+key + ": <" + value+">  ";
    });
    return prefix;
}