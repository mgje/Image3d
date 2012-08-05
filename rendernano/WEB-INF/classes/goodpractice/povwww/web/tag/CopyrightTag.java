/*
 * Created on 12.12.2004 by florian
 */
package goodpractice.povwww.web.tag;

import javax.servlet.jsp.tagext.TagSupport;
import javax.servlet.jsp.JspWriter;

public class CopyrightTag extends TagSupport {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public int doStartTag() {
    	  try {
            JspWriter out = pageContext.getOut();
            out.println("<small>&copy; F. M&uuml;ller, St. D&uuml;renberger, Ph. Nguyen, J. Trinkler, H.-R. Hidber, T. Gyalog, M. Guggisberg " +
            		"<br>" +
            		"goodpr@ctice 2006 -2007 / <A href=\"mailto:info@epistemis.com\">info@epistemis.com</A></small>");
            
    	  } 
    	  catch (Exception ex) { System.out.println("CopyrightTag Error"+ex.getMessage()); }
    	  // Must return SKIP_BODY because we are not supporting a body for this 
    	  // tag.
    	  return SKIP_BODY;
        }
    /**
     * doEndTag is called by the JSP container when the tag is closed
     */
    	public int doEndTag(){
    	   try {
    	    //   JspWriter out = pageContext.getOut();
    	       
    	   } 
    	   catch (Exception ex){System.out.println("CopyrightTag Error"+ex.getMessage());}
    	   return EVAL_PAGE;
    	}

}
