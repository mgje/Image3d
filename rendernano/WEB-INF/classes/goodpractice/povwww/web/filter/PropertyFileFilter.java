/*
 * Created on Jan 21, 2005 by florian
 */
package goodpractice.povwww.web.filter;
import java.io.*;
import java.util.*;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.*;

import goodpractice.povwww.Logger;


public class PropertyFileFilter implements Filter {

    
    
    private Hashtable userList;
    private String loginPage = "/image3d/index.jsp";
    //TODO remove hardcoded parameter loginPage
    /* (non-Javadoc)
     * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
     */
    public void init(FilterConfig arg0) throws ServletException {
        

    }

    /* (non-Javadoc)
     * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
     */
    public void doFilter(ServletRequest request, ServletResponse response,
        FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequ = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;
        
        String uid = request.getParameter("uid");
        String pwd = request.getParameter("pwd");
        if( uid==null || pwd==null ){
            if(httpRequ.getSession().getAttribute(PFUser.class.getName())!=null){
                chain.doFilter(request, response);
                return;
            }
            else{
                httpResp.sendRedirect(loginPage);
                return;
            }
        }
        else{
            try{
                userList = readUserFile();
            }catch(Exception e){ Logger.app(this, "Cannot read user file: " + e);}
            if(userList == null){
                httpResp.sendRedirect(loginPage + "?msg=UserFileUnavailable");
                return;
            }
            else{
                String dbPwd = (String) userList.get(uid);
                if(dbPwd!=null && dbPwd.equals(pwd)){
                    httpRequ.getSession().setAttribute(PFUser.class.getName(), new PFUser(uid, pwd));
                    chain.doFilter(request, response);
                }
                else{
                    httpResp.sendRedirect(loginPage + "?msg=invalidLogin");
                    return;
                }
            }
        }

    }
    
    private Hashtable readUserFile(){
        Hashtable retVal = new Hashtable(10);
        try{
            BufferedReader in = new BufferedReader(new InputStreamReader(getClass().getResourceAsStream("users.pdb")));
            for(String line = in.readLine(); line != null; line = in.readLine()){
                StringTokenizer st = new StringTokenizer(line, ":");
                retVal.put(st.nextToken(),st.nextToken());
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return retVal;
            
    }
    

    /* (non-Javadoc)
     * @see javax.servlet.Filter#destroy()
     */
    public void destroy() {
        // TODO Auto-generated method stub

    }

}

class PFUser{
    private String uid;
    private String pwd;
    public PFUser(String uid, String pwd){
        this.uid = uid;
        this.pwd = pwd;
    }
    public String getUid(){
        return uid;
    }
    public String getPwd(){
        return pwd;
    }
}
