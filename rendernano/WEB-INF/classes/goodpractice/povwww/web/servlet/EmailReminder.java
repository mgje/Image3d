/*
 * Created on Jun 27, 2005 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import java.io.PrintWriter;
import java.util.Properties;

import goodpractice.povwww.Configuration;
import goodpractice.povwww.Logger;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailReminder extends HttpServlet {

    
    /**
	 * 
	 */
	private static final long serialVersionUID = -2896668596216334276L;

	public void doGet(HttpServletRequest request, HttpServletResponse response){
        doPost(request, response);
    }
    
    /*
     * command = email
     * address = desiredAddress
     */
    
    public void doPost(HttpServletRequest request, HttpServletResponse response){
        Logger.dev(this, "Post of Emailer...");
        String command = request.getParameter("command");
        PrintWriter out = null;
        try{
            out = response.getWriter();
        }
        catch(Exception e){
          Logger.dev(this, e.toString());
        }
        if(command==null){
            out.println("Error: no command specified");
            out.flush();
            return;
        }
        else{
            if(command.equals("email")){
                String msgText = "Your ID is " + Configuration.getUser(request);
                Logger.dev(this, "ID: " + Configuration.getUser(request));
                String toAddr = request.getParameter("address");
                Logger.dev(this, "Address: " + toAddr);
                if(toAddr==null){
                    out.println("Error: no address specified");
                    out.flush();
                    return;
                }
                Properties props = System.getProperties();
                props.put("mail.smtp.host", "localhost");
                Logger.dev(this, "Set mail.smtp.host Property");
                Session mailSess = Session.getDefaultInstance(props, null);
                Logger.dev(this, "Obtained Email Session");
                MimeMessage msg = new MimeMessage(mailSess);
                try{
                    msg.setSubject("ID Reminder (image3d)");
                    msg.setFrom(new InternetAddress("nano@unibas.ch"));
                    msg.setText(msgText);
                    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toAddr));
                    Logger.dev(this, "Message all set, sending....");
                    Transport.send(msg);
                    Logger.dev(this, "Message Sent OK");
                }
                catch(MessagingException e){
                    out.println("Error creating email message:");
                    out.println("<br><br>" + e);
                    out.flush();
                    return;
                }
                out.println("A message containing your ID has been sent to " + 
                        toAddr);
                out.flush();
                
                
            }
        }
    }
    
}
