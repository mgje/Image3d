/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import java.io.File;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.*;

import goodpractice.povwww.*;
import goodpractice.povwww.fs.*;
import goodpractice.povwww.proc.*;

import goodpractice.povwww.pov.*;

public class RenderMovie extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private StringBuffer log;

	/**
	 * Parameters to this servlet
	 * 
	 * width, height dimension of the image to be rendered id filename of the
	 * image source (output filename is automatic)
	 * 
	 * 
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		
		 /*
	     * first, write all parameters to session - they may be used by 
	     * the renderForm to keep track of user inputs.
	     */
		
		Logger.dev(this, "Start RenderMovieServlet- Reeding Parameters");
		
	    Hashtable params = new Hashtable();
	    Enumeration Paraenum = request.getParameterNames();
	    while(Paraenum.hasMoreElements()){
	        String key = (String) Paraenum.nextElement();
	        params.put(key, request.getParameter(key));
	        Logger.dev(this, "Param:"+key+request.getParameter(key));
	    }
	    request.getSession().setAttribute("povwwwParamRemember", params);
		
		
		
		try {
			log = new StringBuffer();
			Logger.dev(this, "Start RenderMovieServlet-2nd block Reading Parameters");
			String imageFile = request.getParameter("imageFile");
			String userHome = Configuration.getUserHome(request);
			String aviOut = Configuration.stripExtension(imageFile) + ".flv";
			String imageInput = Configuration.stripExtension(imageFile);
			String imageName = request.getParameter("imageFile");
			String outputFile = userHome + Constants.DIR_MOV
					+ stripExt(imageName) + ".png";

			
			
		
			
			Logger.dev(this, "creating Autoscript:" + imageFile
					+ Configuration.getUserHome(request) + request);
			
			AutoScript as = new AutoScript(imageFile, Configuration
					.getUserHome(request), request,
					Configuration.TEMPLATE_TYPE_MOV_POV,
					Configuration.TEMPLATE_TYPE_MOV_INI);

			try {
				Logger.dev(this, "running Autoscript");
				as.build();
			} catch (Exception e) {
				log.append(e.toString() + "<br>");
				Logger.dev(this, "Error: Log:" + log.toString());
				StackTraceElement[] st = e.getStackTrace();
				for (int i = 0; i < st.length; i++) {
					log.append(st[i].toString() + "<br>");
					if (i > 10)
						break;
				}
			}
            
			/*
			 * create the povjob and execute it
			 */
			log.append("Creating Povjob...<br>");
			Logger.dev(this, "Runnig-PoVJob"+ outputFile);
			I_Job job = new PovMovJob(outputFile, as);
			int exVal = -1;
			try {
				exVal = Spawner.spawn(job);
				Logger.dev(this, "PoV:" + job.getCommand());
			} catch (Exception e) {
				Logger.dev(this, "Render Error" + e.getMessage());
			}

			
			/* Test if Movie_tmp exists */
			
			File uMovietmp = new File(userHome + Constants.DIR_MOV);
			if (!uMovietmp.exists())
				uMovietmp.mkdir();
			
			
						
			
			// meencoder script
/*
			String cmd1 = Configuration.getmencoder()
					+ "mf://"
					+ userHome+ Constants.DIR_MOV
					+ "*.png "
					+ "-mf fps=10:type=png "																																																					
					+ "-ovc lavc -lavcopts vcodec=mjpeg  -o "
					+ userHome+Constants.DIR_MOV+"tmp.avi";
*/
			
//			-mf fps=8:type=png -ovc lavc -lavcopts vcodec=flv:vqscale=2:keyint=5 -ofps 10 -lavfopts i_certify_that_my_video_stream_does_not_use_b_frames -of lavf
	
/*			String cmd1 = Configuration.getmencoder()
			+ "mf://"
			+ userHome+ Constants.DIR_MOV
			+ "*.png "
			+ "-mf fps=8:type=png "																																																					
			+ "-ovc lavc -lavcopts vcodec=flv:vqscale=2:keyint=5 -ofps 10 -lavfopts i_certify_that_my_video_stream_does_not_use_b_frames -of lavf  -o "
			+ userHome+Constants.DIR_MEASURE+aviOut;;
			*/
			String cmd1 = Configuration.getffmpeg()
			+ " -i "
			+ userHome+ Constants.DIR_MOV
			+ imageInput
			+ "%03d.png -y "
			+ userHome+Constants.DIR_MEASURE+aviOut;
			
			
			Logger.dev(this, "Runnig-ffmpeg-XXXX-newChanges");
			 I_Job mencodeJob1 = new MEncoderJob(cmd1);
			 
			 
			 Logger.dev(this, "ffmpeg:" + mencodeJob1.getCommand());
			 int exVal2 = Spawner.spawn(mencodeJob1);
			 
			
			 /*
				String cmd2 = Configuration.getffmpeg()
				+ "-y -r 3 -b 800k -i "+userHome+Constants.DIR_MOV+"tmp.avi "	
				+ userHome+Constants.DIR_MEASURE+aviOut;

			 
			 
				Logger.dev(this, "Runnig-mencoder Phase 2"+ outputFile);
				 I_Job mencodeJob2 = new MEncoderJob(cmd2);
				 
				 
				 Logger.dev(this, "mencoder:" + mencodeJob2.getCommand());
				 int exVal3 = Spawner.spawn(mencodeJob2);
			 
			 */
			 
			 
			 
/*
			FSWriter writer = new FSWriter(userHome);
			String fileId = as.getScriptName();
			writer.deleteFile(fileId);
			fileId = as.getIniName();
			writer.deleteFile(fileId);
*/		            		 
				 
			FSWriter writer = new FSWriter(userHome+Constants.DIR_MOV);	 
			FSReader reader = new FSReader(userHome+Constants.DIR_MOV);
			
			String[] toDelete = { "png" };
			
			reader.setFilenameFilter(toDelete);
			String[] names = reader.getFileNames();
			for (int i = 0; i < names.length; i++) {
				writer.delete_abs_File(userHome+Constants.DIR_MOV+names[i]);
				// Logger.dev(this, "File:" +userHome+Constants.DIR_MOV+names[i]);
			}
		

			/* write server application log to user session */
			HttpSession session = request.getSession();
			session.setAttribute("RenderLog", log);

			//UNCOMMENT if not using AJAX: response.sendRedirect("renderMovieEditor.jsp");
			
			//COMMENT if not using AJAX
			//Write XML to response.
			String strResultXML = "<?xml version=\"1.0\"?><status>success</status>";
			response.setContentType("application/xml");
			response.getWriter().write(strResultXML);

		} catch (Exception e) {
			HttpSession s = request.getSession();
			s.setAttribute("RenderLog", log);
			try {
				response.sendRedirect("rrenderMovieEditor.jsp");
			} catch (Exception err) {
				Logger.dev(this, "Render Servlet Error Redirect: "
						+ err.getMessage());
			}
		}
		

	}

	private String stripExt(String withExt) {
		return withExt.substring(0, withExt.lastIndexOf("."));
	}

}
