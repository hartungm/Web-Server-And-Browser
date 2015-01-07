package edu.gvsu.cis371;


import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

/**
 * Created by kurmasz on 12/19/14.
 */
public class XHTMLExplorer {

  public static String SPACES = "                                                                            ";


  // recursively print the contents of an xhtml tag (i.e., "element")
  public static void printElement(Element e, int depth) {

    String spaces = SPACES.substring(0, depth*3);

    System.out.printf("%s<%s>\n", spaces, e.getNodeName());

    // print each attribute
    NamedNodeMap attributes = e.getAttributes();
    for (int j = 0; j < attributes.getLength(); j++) {
      Node attribute = attributes.item(j);
      System.out.printf("%s\t* %s: %s\n", spaces, attribute.getNodeName(), attribute.getNodeValue());

      // This is just debugging (i.e., make sure I'm doing it right).
      if (attribute.getChildNodes().getLength() != 1 && attribute.getFirstChild().getNodeType() != Node.TEXT_NODE) {
        System.out.println("I don't understand what's happening here.");
      }
    }


    // Print each Child node.
    NodeList nodes = e.getChildNodes();
    for (int j = 0; j < nodes.getLength(); j++) {
      Node node = nodes.item(j);

      if (node instanceof Element) {
        printElement((Element) node, depth + 1);
      } else if (node instanceof Text) {
        // Replace an actual newline with "\n" to appear on the screen
        String text = node.getTextContent().replace("\n", "\\n");
        System.out.printf("%s\t\"%s\"\n", spaces, text);
      } else {
        // Oops, I must have forgot a case.
        System.out.println("Node " + node + " is not an element or text");
      }
    }
  }


  public static void main(String[] args) throws Exception {
    DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder domBuilder = domFactory.newDocumentBuilder();

    String fileName = "data/example1.html";
    if (args.length > 0) {
      fileName = args[0];
    }

    Document document = domBuilder.parse(fileName);
    printElement(document.getDocumentElement(), 0);
  }
}
