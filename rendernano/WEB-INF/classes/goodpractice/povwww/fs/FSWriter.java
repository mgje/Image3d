/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.fs;

import java.io.*;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Arrays;
import java.util.Iterator;
import java.util.regex.Pattern;

import goodpractice.povwww.Configuration;
import goodpractice.povwww.Constants;
import goodpractice.povwww.Logger;

public class FSWriter {

	private String basePath;

	private FSWriter() {
	}

	public FSWriter(String basePath) {
		this.basePath = basePath;
	}
	/** Fast & simple file copy. */
	public static void copy_file(File source, File dest) throws IOException {
		FileChannel in = null, out = null;
		try {
			in = new FileInputStream(source).getChannel();
			out = new FileOutputStream(dest).getChannel();

			long size = in.size();
			MappedByteBuffer buf = in.map(FileChannel.MapMode.READ_ONLY, 0,
					size);

			out.write(buf);

		} finally {
			if (in != null)
				in.close();
			if (out != null)
				out.close();
		}
	}

	public void delete_abs_File(String fileName) {
		try {
			File toDelete = new File(fileName);
			toDelete.delete();
		} catch (Exception e) {
			Logger.dev(this, "FSWriter Error:" + e.getMessage());
		}
	
		
	}
	
	
	
	public void deleteFile(String fileName) throws IOException {
		try {
			File toDelete = new File(basePath + getSubFolder(fileName)
					+ fileName);
			toDelete.delete();
		} catch (Exception e) {
			Logger.dev(this, "FSWriter Error:" + e.getMessage());
		}
	}

	public void mkDir(String dirName) throws IOException {
		File nDir = new File(basePath + dirName + "/");
		nDir.mkdir();
	}

	public void rmDir(String dirName, boolean nonempty) {
		if (!nonempty) {
			File f = new File(dirName);
			f.delete();
		} else {
			File root = new File(dirName);
			recursiveDelete(root);
		}
	}

	public static void initUser(String userName) {
		FSWriter dummy = new FSWriter();
		Logger.app(dummy, "User Initialization:");
		String appBase = Configuration.getAppHome();
		Logger.app(dummy, " appBase: " + appBase);
		File uH = new File(appBase + "devusers/" + userName);
		Logger.app(dummy, " userHome: " + uH);
		if (!uH.exists()){
			Logger.app(dummy, " create userHome: " + uH);
			uH.mkdir();}
		File uT = new File(uH.getAbsolutePath() + "/" + "tmpupload");
		if (!uT.exists())
			uT.mkdir();
		File uM = new File(uH.getAbsolutePath() + "/" + Constants.DIR_MEASURE);
		if (!uM.exists())
			uM.mkdir();
		File uR = new File(uH.getAbsolutePath() + "/" + Constants.DIR_RENDER);
		if (!uR.exists())
			uR.mkdir();
		File uD = new File(uH.getAbsolutePath() + "/" + Constants.DIR_DESC);
		if (!uD.exists())
			uD.mkdir();
		File uThumb = new File(uH.getAbsolutePath() + "/" + Constants.DIR_THUMB);
		if (!uThumb.exists())
			uThumb.mkdir();
		File uMovietmp = new File(uH.getAbsolutePath() + "/" + Constants.DIR_MOV);
		if (!uMovietmp.exists())
			uMovietmp.mkdir();
		
		// List Examples Direcory
		File path_examples = new File(uH.getAbsolutePath() + "/"
				+ Constants.DIR_EXAMPLE);
		Logger.app(dummy, "example_path:" + path_examples.getAbsolutePath());
        
		
		
		/// Copy jpg measurement
		String[] list = path_examples.list(new jpgFilter(".jpg"));
		Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
		Logger.app(dummy, "list files in example");
		for (int i = 0; i < list.length; i++) {
			Logger.app(dummy, "copy:" + list[i]);
			File testData = new File(uH.getAbsolutePath() + "/"
					+ Constants.DIR_EXAMPLE + "/" + list[i]);
			File dest = new File(uH.getAbsolutePath() + "/"
					+ Constants.DIR_MEASURE + "/" + list[i]);

			try {
				copy_file(testData, dest);
				Logger.app(dummy, "Copy Examples worked");
			} catch (IOException e) {
				Logger.app(dummy, "Error Copy Examples:" + e.getMessage());
			}
		}
		
		// Copy rendered images
		File path_examples_rendered = new File(uH.getAbsolutePath() + "/"
				+ Constants.DIR_EXAMPLE_RENDERED);
		Logger.app(dummy, "example_rendered_path:" + path_examples_rendered.getAbsolutePath());
		
		list = path_examples_rendered.list(new jpgFilter(".png"));
		Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
		Logger.app(dummy, "list files in example_rendered_path");
		for (int i = 0; i < list.length; i++) {
			Logger.app(dummy, "copy:" + list[i]);
			File testData = new File(uH.getAbsolutePath() + "/"
					+ Constants.DIR_EXAMPLE_RENDERED + "/" + list[i]);
			File dest = new File(uH.getAbsolutePath() + "/"
					+ Constants.DIR_RENDER + "/" + list[i]);

			try {
				copy_file(testData, dest);
				Logger.app(dummy, "Copy Examples worked");
			} catch (IOException e) {
				Logger.app(dummy, "Error Copy Examples:" + e.getMessage());
			}
		}		
		
		/*** Copy rendered movies ***/
		
		// into measurementpath
		File path_examples_movies_rendered = new File(uH.getAbsolutePath() + "/"
				+ Constants.DIR_EXAMPLE_RENDERED);
		Logger.app(dummy, "example_rendered_path_movies:" + path_examples_movies_rendered.getAbsolutePath());
		
		list = path_examples_movies_rendered.list(new jpgFilter(".flv"));
		Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
		Logger.app(dummy, "list files in example_rendered_path");
		for (int i = 0; i < list.length; i++) {
			Logger.app(dummy, "copy:" + list[i]);
			File testData = new File(uH.getAbsolutePath() + "/"
					+ Constants.DIR_EXAMPLE_RENDERED + "/" + list[i]);
			File dest = new File(uH.getAbsolutePath() + "/"
					+ Constants.DIR_MEASURE + "/" + list[i]);

			try {
				copy_file(testData, dest);
				Logger.app(dummy, "Copy Examples worked");
			} catch (IOException e) {
				Logger.app(dummy, "Error Copy Examples:" + e.getMessage());
			}
		}		
		
		
		
		
		
	}

	/*
	 * 	PRIVATE 
	 */
	private void recursiveDelete(File f) {
		File[] all = f.listFiles();
		for (int i = 0; i < all.length; i++) {
			if (all[i].isDirectory()) {
				recursiveDelete(all[i]);
				all[i].delete();
			} else {
				all[i].delete();
			}
		}
	}

	private String getSubFolder(String filePattern) {
		if (filePattern.startsWith(Constants.PREFIX_RENDER))
			return Constants.DIR_RENDER;
		else if (filePattern.startsWith(Constants.PREFIX_THUMB))
			return Constants.DIR_THUMB;
		else if (filePattern.startsWith(Constants.PREFIX_DESCRIPTION))
			return Constants.DIR_DESC;
		return Constants.DIR_MEASURE;
	}

	

}

class jpgFilter implements FilenameFilter {

	String ending=null;
	
	public jpgFilter(String name) {
	this.ending=name;
	}

	public boolean accept(File directory, String filename) {

		if (filename.endsWith(ending))
			return true;
		return false;

	}

}

