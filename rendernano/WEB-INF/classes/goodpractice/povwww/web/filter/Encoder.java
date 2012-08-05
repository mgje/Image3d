/*
 * Created on Jan 21, 2005 by florian
 */
package goodpractice.povwww.web.filter;


import sun.misc.*;

public class Encoder {

    public static String encodeBase64(String str){
        BASE64Encoder enc = new BASE64Encoder();
        return enc.encode(str.getBytes());
    }
    
}
