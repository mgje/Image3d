/*
 * Created on 11.12.2004 by florian
 */
package goodpractice.povwww.web.tag;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;



public class CookieTag extends TagSupport {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String value = null;
    private String msg = null;

    
    public void setValue(String value){
        this.value = value;
    }
	public String getValue(){
          return(value);
    }
	public void setMsg(String msg){
	    this.msg = msg;
	}
	public String getMsg(){
	    return msg;
	}
/**
* doStartTag is called by the JSP container when the tag is encountered
*/
    public int doStartTag() {
	  try {
        JspWriter out = pageContext.getOut();
        out.println("<p><code>");
        if(msg != null)
            out.println(msg);
	     if (value != null)
	         out.println(value);
        
	  } 
	  catch (Exception ex) { System.out.println("CookieTag"+ex.getMessage()); }
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
	       out.println("</code></p>");
	   } 
	   catch (Exception ex){System.out.println("CookieTag Error"+ex.getMessage());}
	   return EVAL_PAGE;
	}
}