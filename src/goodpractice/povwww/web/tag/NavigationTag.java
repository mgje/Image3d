/*
 * Created on 12.12.2004 by florian
 */
package goodpractice.povwww.web.tag;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

public class NavigationTag extends TagSupport {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = -7392521117579935932L;
	public int doStartTag() {
  	  try {
          JspWriter out = pageContext.getOut();
          out.println("<div style=\"position:absolute;top:5px;right:5px;\">");
          out.println("Navigation: <a href=\"gallery.jsp\">GALLERY</a> | ");
          out.println("<a href=\"documentation.jsp\">Documentation</a>");
          
          
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
  	       out.println("</div>");
  	   } 
  	   catch (Exception ex){System.out.println(ex.getClass()+ex.getMessage());}
  	   return EVAL_PAGE;
  	}
  

}
