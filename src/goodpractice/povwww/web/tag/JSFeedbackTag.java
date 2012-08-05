/*
 * Created on 11.12.2004 by florian
 */
package goodpractice.povwww.web.tag;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;



public class JSFeedbackTag extends TagSupport {
	

    /**
	 * 
	 */
	private static final long serialVersionUID = -476022285372795557L;
	private String message = null;

    

	public void setMessage(String msg){
	    message = msg;
	}
	public String getMessage(){
	    return message;
	}
/**
* doStartTag is called by the JSP container when the tag is encountered
*/
    public int doStartTag() {
	  try {
        JspWriter out = pageContext.getOut();
        out.println("<font style=\"color:red;\">Message:<br>");
        out.println(message);
	  } 
	  catch (Exception ex) { System.out.println(ex.getClass()+ex.getMessage()); }
	  // Must return SKIP_BODY because we are not supporting a body for this 
	  // tag.
	  return SKIP_BODY;
    }
/**
 * doEndTag is called by the JSP container when the tag is closed
 */
	public int doEndTag(){
	   try {
        	JspWriter out = pageContext.getOut();
	       out.println("</font>");
	   } 
	   catch (Exception ex){System.out.println(ex.getClass()+ex.getMessage());}
	   return EVAL_PAGE;
	}
}