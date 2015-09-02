package jp.ac.u_tokyo.k.is;

import java.util.HashMap;

import org.codehaus.jackson.JsonNode;

public class Node extends DataObject{
    public int angle;
    public JsonNode position;
    public JsonNode size;
    public JsonNode attrs;
    public String id;
    public String type;
    public int z;

    private String nodeURI = SF.NS+"node#";
    
    public String toString(){
        return "angle:"+angle+"position"+position.toString()+"id:"+id+"type:"+type+"z"+z;
    }
    public HashMap<String,String> getFields(){
        HashMap<String,String> map = new HashMap<String,String>();
        map.put("id",id);
        map.put("angle",String.valueOf(angle));
        map.put("type","Node");
        map.put("shape",type);
        map.put("position_x",position.get("x").asText());
        map.put("position_y",position.get("y").asText());
        map.put("height",size.get("height").asText());
        map.put("width",size.get("width").asText());
        map.put("fill_color",attrs.get("rect").get("fill").asText());
        map.put("text_color",attrs.get("text").get("fill").asText());
        map.put("text",attrs.get("text").get("text").asText());
        map.put("z",String.valueOf(z));
        super.targetURI = nodeURI+id;
        return map;

    }
}
