/*
 * Created on 07.12.2004 by florian
 */
package goodpractice.povwww.pov;


import java.util.*;


public class ScriptGenerator {

    
    /*
     * generate a script 
     */
    /*public static String generateScript(HttpServletRequest request, String scriptTemplate){
       
       String[] params = getParameters(scriptTemplate);
       for(int i = 0; i < params.length; i++){
           String requestParameter = getParameterName(params[i]);
           String repl = request.getParameter(requestParameter);
           scriptTemplate = scriptTemplate.replaceAll(params[i], repl);
       }
       return scriptTemplate;
    }*/
    
    
    
    
    public static String getParameterName(String inp){
        if(inp.indexOf(":")<0)
            return inp.substring(inp.indexOf("@")+1, inp.lastIndexOf("@"));
        else
            return inp.substring(inp.indexOf("@")+1, inp.indexOf(":"));
    }
    
    
    /* get an array of all the parameters as they have to be listed
     * in the form for the render servlet.
     */
    public static Parameter[] getFormParameters(String scriptTemplate){
        String[] retVal = getParameters(scriptTemplate);
        Parameter[] params = new Parameter[retVal.length];
        
        for(int i = 0; i < retVal.length; i++){
            params[i] = new Parameter(getParameterName(retVal[i]));
            if(retVal[i].indexOf(":")>=0){
                // remove head and tail, they contain no information
                retVal[i] = retVal[i].replaceAll("#","");
                retVal[i] = retVal[i].replaceAll("@","");
                params[i].setComplex(true);
                // get the three parts of the parameter descriptor: name, value, display
                StringTokenizer stOuter = new StringTokenizer(retVal[i],":");
                stOuter.nextElement(); // discard name, we allready have it
                String vals = stOuter.nextToken();
                // parse the possible values
                StringTokenizer stVals = new StringTokenizer(vals, ";");
                List tmpList = new ArrayList();
                while(stVals.hasMoreTokens()){
                    tmpList.add(stVals.nextToken());
                }
                String[] tmpArr = new String[tmpList.size()];
                for(int j = 0; j < tmpArr.length; j++){
                    tmpArr[j] = tmpList.get(j).toString();
                }
                params[i].setValues(tmpArr);
                
                // parse the display values to be used in forms, if any are available
                if(stOuter.hasMoreElements()){
                    // this means the parameter descriptor contains the optional label info
                    String labels = stOuter.nextToken();
                    StringTokenizer stLabels = new StringTokenizer(labels, ";");
                    tmpList = new ArrayList();
                    while(stLabels.hasMoreTokens()){
                        tmpList.add(stLabels.nextToken());
                    }
                    tmpArr = new String[tmpList.size()];
                    for(int j = 0; j < tmpArr.length; j++){
                        tmpArr[j] = tmpList.get(j).toString();
                    }
                    params[i].setLabels(tmpArr);
                }
//              // parse the java applet class to handle the presentation of the parameter
                if(stOuter.hasMoreElements()){
                    String cName = stOuter.nextToken();
                    params[i].setAppletTag(cName);
                }
            }

        }
        return params;
    }

    /*
     * get an array of all parameters as they occur in the script, i.e. 
     * with identifier pre- and suffix: #@param@
     */
    public static String[] getParameters(String scriptTemplate){
        List paramList = new ArrayList();
        int scanIndex = 0;
        int pos = -1;
        while ( (pos = scriptTemplate.indexOf("#@",scanIndex)) >= 0 ){
            //System.out.println("Scanindex: " + scanIndex);
            StringBuffer param = new StringBuffer();
            int prog = pos;
            char c = scriptTemplate.charAt(prog);
            while( prog-pos <=2 || c != '@'){
                param.append(c);
                c = scriptTemplate.charAt(++prog);
            }
            param.append(c); // append final @
            paramList.add(param.toString());
            scanIndex = prog;
        }
        String[] retVal = new String[paramList.size()];
        for(int i = 0; i < retVal.length; i++){
            retVal[i] = paramList.get(i).toString();
        }
        return retVal;
    }
    
    
    
	//test
	public static void main(String[] args) throws Exception{
	    String test = "#@Size:+W800 +H600;+W640 +H480:800x600;640x480@ hallo #@das:val1:label1@ #@sollte:1;1:2@ jetzt #@irgendwie@ verarbeitet #@werden@";
	    
	    Parameter[] formParam = getFormParameters(test);
	    for(int i = 0; i < formParam.length; i++){
	        System.out.println(formParam[i]);
	    }
	    System.out.println("Parameter Names:");
	    String[] names = ScriptGenerator.getParameters(test);
	    for(int i = 0; i < names.length; i++){
	        System.out.println(names[i] + " = " + ScriptGenerator.getParameterName(names[i]));
	    }
	    System.out.println("Now try to replace:");
	    System.out.println(test.replaceAll("\\Q#@Size:+W800 +H600;+W640 +H480:800x600;640x480@\\E", "replaced"));
	    
	    
	    
	    

	    

    
	}
    
    
    
}
