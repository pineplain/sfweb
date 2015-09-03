package jp.ac.u_tokyo.k.is;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * UIを表示するURLに対応するコントローラ.
 */
@Controller
public class UIController {
    private static final Logger logger = Logger.getLogger(UIController.class);

    @Autowired
    private HttpServletRequest request;

    /**
     * 検索
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/workflowEditor", method = RequestMethod.GET)
    public String index(Model model, String resourceUri) throws Exception {
        model.addAttribute("resourceUri", resourceUri);
        return "index";
    }

    /**
     * HOME画面
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index2() throws Exception {
        return "index2";
    }

    /**
     * ワークフローのリスト
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/workflowList", method = RequestMethod.GET)
    public String workflowList() throws Exception {
        return "workflowList";
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
    public @ResponseBody String handleException(Exception ex, HttpServletRequest request) {
        return ex.getMessage();
    }
}
