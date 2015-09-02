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
import java.util.List;
import java.util.Set;

public abstract class DataObject {

    public String targetURI;
    private String projectID;
    private List<String> rePredicates;

    public abstract HashMap<String,String> getFields();

    public void post(String url){
            HashMap<String,String> fields = getFields();
            Set<String> keys = fields.keySet();
            for (String key:keys){
                String subject = this.targetURI;
                String predicate = SF.NS +key;
                String object =  fields.get(key);
                String flag = "true";
                if (rePredicates!=null){
                    for (String rePredicate : rePredicates){
                        if(predicate.equals(SF.NS+rePredicate)) flag = "false";
                    }
                }
                postSVO(url,subject,predicate,object,flag);

                String parent = SF.NS+"project#"+projectID;
                predicate = SF.NS+"child";
                object = this.targetURI;
                flag = "false";
                postSVO(url,parent,predicate,object,flag);
            }
    }

    /**
     * @param projectID the projectID to set
     */
    public void setProjectID(String projectID) {
        this.projectID = projectID;
    }


    /**
     * @param rePredicates the rePredicates to set
     */
    public void setRePredicates(List<String> rePredicates) {
        this.rePredicates = rePredicates;
    }

    protected void postSVO(String url,String subject, String predicate, String object, String flag){
        try{
            URL urlObject = new URL(url);
            HttpURLConnection connection = null;

            try {
                connection = (HttpURLConnection) urlObject.openConnection();
                connection.setDoOutput(true);
                connection.setRequestMethod("POST");
                OutputStream os = connection.getOutputStream(); 
                String postStr = "subject="+subject+"&predicate="+predicate+"&object="+object+"&literalFlag="+flag;
                System.out.println(postStr);
                PrintStream ps = new PrintStream(os);
                ps.print(postStr);
                ps.close();

                if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    try (InputStreamReader isr = new InputStreamReader(connection.getInputStream(),
                                                                       StandardCharsets.UTF_8);
                         BufferedReader reader = new BufferedReader(isr)) {
                        String line;
                        while ((line = reader.readLine()) != null) {
                            System.out.println(line);
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
    }


}
