package edu.gvsu.cis371.starterbrowser;

import java.io.IOException;
import java.util.List;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.nio.file.Files;

/**
 * This class can serve as starter code for a simple web browser.
 * It provides a basic GUI setup:  and address bar, and a scrollable panel on which to draw.
 * <p/>
 * Created by kurmasz on 12/17/14.
 */
public class StarterBrowser {


  private JFrame frame;
  private JTextField addressBar;
  private JScrollPane scrollPane;
  private StarterDisplay display;


  public StarterBrowser() {

    frame = new JFrame("CS 371 Starter Browser");
    frame.setSize(500, 500);
    addressBar = new JTextField("sampleInput/starterSample.txt");

    display = new StarterDisplay();

    Dimension screenSize = java.awt.Toolkit.getDefaultToolkit().getScreenSize();
    screenSize.width /= 2;
    screenSize.height /= 2;

    display.setPreferredSize(screenSize);
    scrollPane = new JScrollPane(display);


    frame.getContentPane().add(addressBar, BorderLayout.NORTH);
    frame.getContentPane().add(scrollPane, BorderLayout.CENTER);
    frame.setVisible(true);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.pack();

    // Respond to the user pressing <enter> in the address bar.
    addressBar.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent e) {
        String textInBar = addressBar.getText();

        // Replace this with the code that loads
        // text from a web server
        loadFile(textInBar);
      }
    });

    display.addMouseListener(new MouseAdapter() {
      @Override
      public void mouseClicked(MouseEvent e) {
        super.mouseClicked(e);
        clicked(e.getPoint());
      }
    });
  }

  private void clicked(Point point) {
    // Respond to a mouse click in the display
    Color c = display.getColor(point);
    if (c != null) {
      display.setColor(c);
      display.repaint();
    }

  }

  private void loadFile(String textInBar) {
    File file = new File(textInBar);
    List<String> contents = null;
    try {

      // WARNING!! This code is missing a lot of important
      // checks ("does the file exist", "is it a text file", "is it readable", etc.)
      contents = Files.readAllLines(file.toPath());
    } catch (IOException e) {
      System.out.println("Can't open file " + file);
      e.printStackTrace();
    }
    display.setText(contents);
    frame.repaint();
  }


  public static void main(String[] args) {
    new StarterBrowser();
  }


}
