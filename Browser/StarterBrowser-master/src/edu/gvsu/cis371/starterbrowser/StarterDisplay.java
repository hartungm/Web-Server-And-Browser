package edu.gvsu.cis371.starterbrowser;

import javax.swing.*;
import java.awt.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

/**
 * This class demonstrates a simple technique of laying out text "by hand"
 * <p/>
 * Also demonstrates how to change fonts and colors.
 * <p/>
 * Created by kurmasz on 12/17/14.
 */
public class StarterDisplay extends JPanel {

  private static final int MARGIN = 10;
  private List<String> content;
  private HashMap<Rectangle, Color> links = new HashMap<Rectangle, Color>();
  private Color defaultColor;

  public void setText(List<String> c) {
    content = c;
    defaultColor = Color.black;
  }

  public void setColor(Color c) {
    defaultColor = c;
  }

  @Override
  public void paintComponent(Graphics g) {

    if (content == null) {
      return;
    }

    FontMetrics metrics = g.getFontMetrics();
    int line_height = metrics.getHeight();
    int panel_width = getWidth() - MARGIN * 2;

    int x = MARGIN;
    int y = line_height;

    // save the original font in case we change it.
    Font originalFont = g.getFont();


    // Iterate over each line.
    for (String line : content) {
      Scanner words = new Scanner(line);

      // iterate over each word.
      while (words.hasNext()) {

        int style = Font.PLAIN;
        String nextWord = words.next();


        // A simple example of how to handle a *one-word* markup
        if (nextWord.startsWith("*") && nextWord.endsWith("*")) {
          // remove the markup.
          nextWord = nextWord.substring(1, nextWord.length() - 1);
          style = Font.BOLD;
        }


        String wordAndSpace = nextWord + " ";
        int word_width = metrics.stringWidth(wordAndSpace);

        // If there isn't room for this word, go to the next line
        if (x + word_width > panel_width) {
          x = MARGIN;
          y += line_height;
        }

        // A simple example of how to handle links. A word of the form (#123456) will be
        // represented as a link that, when clicked on, will change the text color.
        Color color = getColor(nextWord);
        if (color != null) {
          g.setColor(color);
          Rectangle rect = new Rectangle(x, y -line_height, word_width, line_height);
          links.put(rect, color);
         // g.drawRect(rect.x, rect.y, rect.width, rect.height);
        } else {
          g.setColor(defaultColor);
        }


        // draw the word
        g.setFont(originalFont.deriveFont(style));
        g.drawString(wordAndSpace, x, y);


        x += word_width;

      } // end of the line

      // move to the next line
      x = MARGIN;
      y += line_height;
    } // end of all ines

    // make this JPanel bigger if necessary.
    // Calling re-validate causes the scroll bars to adjust, if necessary.
    if (y > getHeight()) {
      setPreferredSize(new Dimension(x, y + line_height + 2 * MARGIN));
      revalidate();
    }
  }

  private static Color getColor(String word) {
    if (word.length() == 9 && word.startsWith("(#") && word.endsWith(")")) {
      return new Color(Integer.parseInt(word.substring(2, 8), 16));
    } else {
      return null;
    }
  }

  // Return the color value of the color link at {@code point}, or
  // return null if {@code point} doesn't point to a color link.
  public Color getColor(Point point) {
    for (Map.Entry<Rectangle, Color> entry : links.entrySet()) {
      if (entry.getKey().contains(point)) {
        return entry.getValue();
      }
    }
    return null;
  }
}
