package jp.ac.u_tokyo.k.is;

import java.io.IOException;
import java.util.Iterator;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class MetadataController {

    
    @RequestMapping(value="/addWorkflow", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
    public @ResponseBody String addWorkflow(@RequestParam String projectID,@RequestParam String workflowJSON, @RequestParam String properties)
            throws JsonProcessingException, IOException {
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(workflowJSON);
        JsonNode cells  = root.get("cells");
        Iterator<JsonNode> fieldNames = cells.getElements();

        DataObject celldata;
        while (fieldNames.hasNext()){
            JsonNode cell = fieldNames.next();
            String type = (String) cell.get("type").toString();
            if (type.equals("\"basic.Rect\"")){
                celldata = mapper.readValue(cell,Node.class);
            }else if (type.equals("\"link\"")){
                celldata = mapper.readValue(cell,Link.class);
            }else {
                celldata = null;
            }
            System.out.println(projectID);
            celldata.setProjectID(projectID);
            celldata.post("http://heineken.is.k.u-tokyo.ac.jp/forest3/metadata/add");
        }

        JsonNode props = mapper.readTree(properties).get("props");
        Iterator<JsonNode> propChildren = props.getElements();
        while (propChildren.hasNext()){
            JsonNode prop = propChildren.next();
            DataObject propdata = mapper.readValue(prop,Property.class);
            propdata.post("http://heineken.is.k.u-tokyo.ac.jp/forest3/metadata/add");
        }

        return "success /metadata/addWorkflow";
    }
}
