package jp.ac.u_tokyo.k.is;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
        if(source.has("id") != false && target.has("id") != false){ 
            map.put("source",nodeURI+source.get("id").asText());
            map.put("target",nodeURI+target.get("id").asText());
        }
        else{ 
            return map;
        }
        map.put("angle",String.valueOf(angle));
        map.put("id",id);
        map.put("type","Link");
        map.put("typeClass","Link");
        map.put("shape",type);
        map.put("z",String.valueOf(z));
        map.put("stroke",attrs.get(".connection").get("stroke").asText());
        map.put("stroke_width",attrs.get(".connection").get("stroke-width").asText());
        map.put("d",attrs.get(".marker-target").get("d").asText());
        map.put("fill",attrs.get(".marker-target").get("fill").asText());
        super.targetURI = linkURI+id;
        List<String> rePredicates = new ArrayList<String>();
        rePredicates.add("source");
        rePredicates.add("target");
        super.setRePredicates(rePredicates);
        return map;

    }

}
