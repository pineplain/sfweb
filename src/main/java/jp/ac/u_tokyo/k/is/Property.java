package jp.ac.u_tokyo.k.is;

import java.util.HashMap;

public class Property extends DataObject{
    
    public String comment;
    public String id;
    public String location;
    public String taskName;
    public String type;
    public String worker;
    public String workload;

    public HashMap<String,String> getFields(){
        HashMap<String,String> map = new HashMap<String,String>();
        map.put("comment",comment);
        map.put("location",location);
        map.put("task_name",taskName);
        map.put("worker",worker);
        map.put("workload",workload);
        super.targetURI = SF.NS+this.type+"#"+id;
        return map;
    }
}
