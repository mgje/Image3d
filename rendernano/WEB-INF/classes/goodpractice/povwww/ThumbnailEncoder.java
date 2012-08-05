/*
 * Created on Jan 28, 2005 by Florian Mueller, University of Basel
 * 
 * This class creates a small thumbnail image from a larger image.
 * 
 */
package goodpractice.povwww;

import java.io.*;
import java.awt.image.*;
import java.awt.*;
import com.sun.image.codec.jpeg.*;

/**
 * 
 * @author florian
 *
 * Used to create small jpeg versions of larger images
 */
public class ThumbnailEncoder {

    public ThumbnailEncoder(){}
    
    
    /**
     * Encodes an image to a jpeg file using default resolution.
     * @param inFile The name of the file that should be encoded
     * @param outFile  The name of the ouput jpeg file
     * @throws Exception
     */
    public void encode(String inFile, String outFile) throws Exception{
        encode(inFile, outFile, 100, 100);
    }
    
/**
 * Encodes an image to a jpeg file using a specified resolution.
 * @param inFile The name of the file that should be encoded
 * @param outFile The name of the output jpeg file
 * @param width The width of the encoded file
 * @param height The height of the encoded file
 * @throws Exception
 */
    public void encode(String inFile, String outFile, int width, int height) throws Exception{
        // read original image
        Logger.dev(this, "Start Encoding (" + inFile + " to " + outFile + ")");
        Image image = Toolkit.getDefaultToolkit().createImage(inFile);
        MediaTracker mediaTracker = new MediaTracker(new Container());
        mediaTracker.addImage(image, 0);
        mediaTracker.waitForID(0);
        // determine thumbnail size
        int thumbWidth = width;
        int thumbHeight = height;
        double thumbRatio = (double)thumbWidth / (double)thumbHeight;
        int imageWidth = image.getWidth(null);
        int imageHeight = image.getHeight(null);
        double imageRatio = (double)imageWidth / (double)imageHeight;
        if (thumbRatio < imageRatio) {
	      thumbHeight = (int)(thumbWidth / imageRatio);
	    } else {
	      thumbWidth = (int)(thumbHeight * imageRatio);
	    }
	    // draw original image to thumbnail image object and
	    // scale it to the new size on-the-fly
        BufferedImage thumbImage = new BufferedImage(thumbWidth, thumbHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics2D = thumbImage.createGraphics();
	    graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
	      RenderingHints.VALUE_INTERPOLATION_BILINEAR);
	    graphics2D.drawImage(image, 0, 0, thumbWidth, thumbHeight, null);
	    // save thumbnail image to outfile
	    Logger.dev(this, "\tWrite jpeg to FS...");
	    BufferedOutputStream out = new BufferedOutputStream(new
	      FileOutputStream(outFile));
	    JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
	    JPEGEncodeParam param = encoder.
	      getDefaultJPEGEncodeParam(thumbImage);
	    int quality = 100;
	    quality = Math.max(0, Math.min(quality, 100));
	    param.setQuality((float)quality / 100.0f, false);
	    encoder.setJPEGEncodeParam(param);
	    encoder.encode(thumbImage);
	    out.close(); 
	    Logger.dev(this, "\tDone.");
	    }
    
    
    public static void main(String[] args) throws Exception {
        ThumbnailEncoder t = new ThumbnailEncoder();
        t.encode("/home/florian/test/in.png", "/home/florian/test/out.jpg");
    }
    
}
