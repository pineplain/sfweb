package jp.ac.u_tokyo.k.is;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
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
            celldata.add("http://heineken.is.k.u-tokyo.ac.jp/forest3/metadata/add");
        }

        JsonNode props = mapper.readTree(properties).get("props");
        Iterator<JsonNode> propChildren = props.getElements();
        while (propChildren.hasNext()){
            JsonNode prop = propChildren.next();
            DataObject propdata = mapper.readValue(prop,Property.class);
            propdata.add("http://heineken.is.k.u-tokyo.ac.jp/forest3/metadata/add");
        }

        return "success /metadata/addWorkflow";
    }

    @RequestMapping(value="/getWorkflow", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
    public @ResponseBody String getWorkflow(@RequestParam String projectID){
        String result = "";
        String query = "PREFIX sf: <http://sfweb.is.k.u-tokyo.ac.jp/> SELECT ?childURI ?v ?o WHERE {?projectURI sf:child ?childURI . ?projectURI sf:projectId \""+projectID+"\" . ?childURI ?v ?o. } ";
        String flag = "false";
        String url  = "http://heineken.is.k.u-tokyo.ac.jp/forest3/sparql";
        try{
            URL urlObject = new URL(url);
            HttpURLConnection connection = null;

            try {
                connection = (HttpURLConnection) urlObject.openConnection();
                connection.setDoOutput(true);
                connection.setRequestMethod("POST");
                OutputStream os = connection.getOutputStream(); 
                String postStr = "query="+query+"&infFlag="+flag;
                System.out.println(postStr);
                PrintStream ps = new PrintStream(os);
                ps.print(postStr);
                ps.close();
                
                if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    try (InputStreamReader isr = new InputStreamReader(connection.getInputStream(),StandardCharsets.UTF_8);
                         BufferedReader reader = new BufferedReader(isr)) {
                        String line;
                        
                        while ((line = reader.readLine()) != null) {
                            System.out.println(line);
                            result += line;
                        }
                    }
                }
            } finally {
                if (connection != null) {
                    connection.disconnect();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return result;
    }
}
