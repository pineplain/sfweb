package jp.ac.u_tokyo.k.is;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Set;

import org.codehaus.jackson.JsonNode;

public class Link extends DataObject{
    public int angle;
    public JsonNode size;
    public JsonNode attrs;
    public String id;
    public String type;
    public JsonNode source;
    public JsonNode target;
    public int z;

    private String linkURI = SF.NS+"link#";
    private String nodeURI = SF.NS+"node#";
    
    public String toString(){
        return "angle:"+angle+" source:"+source.toString()+" id:"+id+" type:"+type+" z:"+z;
    }


    public HashMap<String,String> getFields(){
        HashMap<String,String> map = new HashMap<String,String>();
        map.put("angle",String.valueOf(angle));
        map.put("type","Link");
        map.put("shape",type);
        map.put("z",String.valueOf(z));
        map.put("source",nodeURI+source.get("id").asText());
        map.put("target",nodeURI+source.get("id").asText());
        map.put("stroke",attrs.get(".connection").get("stroke").asText());
        map.put("stroke_width",attrs.get(".connection").get("stroke-width").asText());
        map.put("d",attrs.get(".marker-target").get("d").asText());
        map.put("fill",attrs.get(".marker-target").get("fill").asText());
        super.targetURI = linkURI+id;
        return map;

    }

}