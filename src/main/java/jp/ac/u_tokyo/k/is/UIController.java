package jp.ac.u_tokyo.k.is;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * UIを表示するURLに対応するコントローラ.
 */
@Controller
public class UIController {

	@Autowired
	private HttpServletRequest request;

	/**
	 * HOME画面
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String index() throws Exception {
		return "index";
	}

	/**
	 * ワークフローのリスト
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list() throws Exception {
		return "list";
	}

	/**
	 * ワークフローの閲覧
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public String view(Model model, @RequestParam String resourceUri)
			throws Exception {
		model.addAttribute("resourceUri", resourceUri);
		return "view";
	}

	/**
	 * ワークフローの編集
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit(Model model, @RequestParam String resourceUri)
			throws Exception {
		model.addAttribute("resourceUri", resourceUri);
		return "edit";
	}

	@ExceptionHandler(Exception.class)
	@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
	public @ResponseBody String handleException(Exception ex,
			HttpServletRequest request) {
		return ex.getMessage();
	}
}
