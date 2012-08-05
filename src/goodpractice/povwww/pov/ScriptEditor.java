/*
 * Created on Apr 19, 2005 by florian
 */
package goodpractice.povwww.pov;

import javax.swing.*;
import javax.swing.JApplet;

import java.awt.Color;
import java.io.*;
import java.net.URL;

import javax.swing.text.*;

public class ScriptEditor extends JApplet {

    /**
	 * 
	 */
	private static final long serialVersionUID = -7965761198865232464L;
	JMenuBar menubar;
    JTextPane editor;
    
    public void init() {
        menubar= new JMenuBar();
        JMenu file = new JMenu("File...");
        JMenuItem save = new JMenuItem("Save Script");
        JMenuItem open = new JMenuItem("Open Script...");
        
        file.add(save);
        file.add(open);
        menubar.add(file);
        JMenu edit = new JMenu("Edit...");
        JMenuItem validate = new JMenuItem("Validate Script");
        JMenuItem preparse = new JMenuItem("Preparse RegExp");
        edit.add(validate);
        edit.add(preparse);
        menubar.add(edit);
        this.setJMenuBar(menubar);
        editor = new JTextPane();
        try{
            BufferedReader in = new BufferedReader(new InputStreamReader(
                new URL(this.getParameter("url")).openStream()));
            StyledDocument doc = editor.getStyledDocument();
            addStylesToDocument(doc);
            String txt = "";
            for(String tmp = in.readLine(); tmp != null; tmp = in.readLine()){
                txt += tmp + "\n";
            }
            int len = txt.length();
            for(int i = 0; i < len; i++){
                if(txt.charAt(i)=='#'){
                    int offNr = i;
                    String style = "";
                    ++i;
                    if(i<len&&txt.charAt(i)=='@'){
                        while(++i<len){
                            if(txt.charAt(i)=='@'){
                                style = "povapp";
                                break;
                            }
                        }
                    }
                    else{
                    	while(++i<len){
                        	if(txt.charAt(i)==' '){
                        	    style = "povmeta";
                        	    break;
                        	}
                    	}
                    }
                	doc.insertString(doc.getLength(), txt.substring(offNr, i+1), doc.getStyle(style));
                }
                else if(txt.charAt(i)=='"'){
                    int offAfz = i;
                    while(++i<len){
                        if(txt.charAt(i)=='"'){
                            break;
                        }
                    }
                    doc.insertString(doc.getLength(), txt.substring(offAfz, i+1), doc.getStyle("string"));
                }
                else{
                    doc.insertString(doc.getLength(), String.valueOf(txt.charAt(i)), doc.getStyle("regular"));
                }
            }
            editor.setDocument(doc);
            
        }
        catch(Exception e){
            System.out.println("ScriptEditor Error"+e.getMessage());
            editor.setText("Script Editor [errorOnLoad]");
        }
        JScrollPane scroller = new JScrollPane(editor);
        getContentPane().add(scroller);
        setVisible(true);
    }
    
    protected void addStylesToDocument(StyledDocument doc) {
        //Initialize some styles.
        Style def = StyleContext.getDefaultStyleContext().
                        getStyle(StyleContext.DEFAULT_STYLE);

        
        Style regular = doc.addStyle("regular", def);
        StyleConstants.setFontFamily(def, "SansSerif");

        Style s = doc.addStyle("italic", regular);
        StyleConstants.setItalic(s, true);

        s = doc.addStyle("bold", regular);
        StyleConstants.setBold(s, true);

        s = doc.addStyle("small", regular);
        StyleConstants.setFontSize(s, 10);

        s = doc.addStyle("large", regular);
        StyleConstants.setFontSize(s, 16);
        
        s = doc.addStyle("povapp", regular);
        StyleConstants.setForeground(s, Color.BLUE);
        
        s = doc.addStyle("povmeta", regular);
        StyleConstants.setForeground(s, Color.RED);
        StyleConstants.setBold(s, true);
        
        s = doc.addStyle("string", regular);
        StyleConstants.setForeground(s, Color.GREEN);
        StyleConstants.setItalic(s, true);

        
    }
    
}
