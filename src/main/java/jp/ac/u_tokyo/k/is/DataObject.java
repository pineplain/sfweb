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

public abstract class DataObject {

    public String targetURI;
	public abstract HashMap<String,String> getFields();
    public void post(String url){
        try{
            URL urlObject = new URL(url);
            HttpURLConnection connection = null;
            HashMap<String,String> fields = getFields();
            Set<String> keys = fields.keySet();
            for (String key:keys){
                String subject = this.targetURI;
                String predicate = SF.NS +key;
                String object =  fields.get(key);
                try {
                    connection = (HttpURLConnection) urlObject.openConnection();
                    connection.setDoOutput(true);
                    connection.setRequestMethod("POST");
                    OutputStream os = connection.getOutputStream(); 
                    String flag = "true";
                    if(key.equals("source") || key.equals("target")) flag = "false";
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
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
