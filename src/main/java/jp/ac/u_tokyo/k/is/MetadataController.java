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

import org.apache.log4j.Logger;
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

    private static final Logger logger = Logger.getLogger(MetadataController.class);

    private String addUrl;
    private String deleteUrl;
    private String sparqlUrl;

    @RequestMapping(value="/addWorkflow", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
    public @ResponseBody String addWorkflow(@RequestParam String projectID,@RequestParam String workflowJSON, @RequestParam String properties)
            throws JsonProcessingException, IOException {

        //logger.info(new Throwable().getStackTrace()[0].getClassName() + " : "+ new Throwable().getStackTrace()[0].getMethodName() + " : properties >>> ");
        //System.out.println(properties);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(workflowJSON);
        JsonNode cells  = root.get("cells");
        Iterator<JsonNode> fieldNames = cells.getElements();

        String url = sparqlUrl;
        String query = "SELECT DISTINCT ?o WHERE {<"+SF.NS+"project#"+projectID+"> <"+SF.NS+"child> ?o . }";
        String postStr = "query="+query+"&infFlag=false";
        JsonNode deleteJson = mapper.readTree(post(url,postStr));

        for (JsonNode target :deleteJson.get("results").get("bindings")){
            String targetURI = target.get("o").get("value").asText();
            url =deleteUrl;
            postStr = "subject="+targetURI;
            post(url,postStr);
        }

        url = deleteUrl;
        postStr = "subject="+SF.NS+"project#"+projectID+"&predicate="+SF.NS+"child";
        post(url,postStr);

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
            celldata.setProjectID(projectID);
            celldata.add(addUrl);
        }

        JsonNode props = mapper.readTree(properties).get("props");
        Iterator<JsonNode> propChildren = props.getElements();
        while (propChildren.hasNext()){
            JsonNode prop = propChildren.next();
            DataObject propdata = mapper.readValue(prop,Property.class);
            propdata.setProjectID(projectID);
            propdata.add(addUrl);
        }

        return "success /metadata/addWorkflow";
    }

    @RequestMapping(value="/getWorkflow", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
    public @ResponseBody String getWorkflow(@RequestParam String projectID){
        String result = "";
        String query = "PREFIX sf: <http://sfweb.is.k.u-tokyo.ac.jp/> SELECT ?childURI ?v ?o WHERE {?projectURI sf:child ?childURI . ?projectURI sf:projectId \""+projectID+"\" . ?childURI ?v ?o. } ";
        String flag = "false";
        String url  = sparqlUrl;
        String postStr = "query="+query+"&infFlag="+flag;
        result=post(url,postStr);
        return result;
    }

    public String post(String url, String postStr){
        String result = "";
        try{
            URL urlObject = new URL(url);
            HttpURLConnection connection = null;

            try {
                connection = (HttpURLConnection) urlObject.openConnection();
                connection.setDoOutput(true);
                connection.setRequestMethod("POST");
                OutputStream os = connection.getOutputStream();
                PrintStream ps = new PrintStream(os);
                ps.print(postStr);
                ps.close();

                if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    try (InputStreamReader isr = new InputStreamReader(connection.getInputStream(),StandardCharsets.UTF_8);
                        BufferedReader reader = new BufferedReader(isr)) {
                        String line;

                        while ((line = reader.readLine()) != null) {
                            //System.out.println(line);
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

    /**
     * @param addUrl the addUrl to set
     */
    public void setAddUrl(String addUrl) {
        this.addUrl = addUrl;
    }

    /**
     * @param deleteUrl the deleteUrl to set
     */
    public void setDeleteUrl(String deleteUrl) {
        this.deleteUrl = deleteUrl;
    }

    /**
     * @param sparqlUrl the sparqlUrl to set
     */
    public void setSparqlUrl(String sparqlUrl) {
        this.sparqlUrl = sparqlUrl;
    }
}
