import javax.swing.*;     
import java.awt.*;
import java.awt.event.*;
import java.text.ParseException;

/**
 * ReservationGUI.java - creates GUI to enter date to create reservation
 * @author Sarah Heredia
 * @version 12/09/2011
 */
public class ReservationGUI 
{
	private MakeReservation thisReservation;

	public Component createComponents() {
        
		// Labels
		final JLabel 
			labFlightNo 	= new JLabel("Flight Number"),
			labFlightDate	= new JLabel("Flight Date (MM-DD-YYYY)"),
			labFName 		= new JLabel("Passenger First Name"),
			labLName 		= new JLabel("Passenger Last Name"),
			labDob			= new JLabel("Passenger Date of Birth (MM-DD-YYYY)");
		
		// Text Fields
		final JTextField
			textFlightNo 	= new JTextField(),
			textFlightDate	= new JTextField(),
			textFName 		= new JTextField(),
			textLName 		= new JTextField(),
			textDob			= new JTextField();
		
		// JCalendar
		
		// Button and listener
		final JButton submitButton = new JButton("Submit");
		submitButton.addActionListener(new ActionListener() {
       public void actionPerformed(ActionEvent e) 
       {
        try 
        {
        	thisReservation = new MakeReservation
			(
				textFlightNo.getText(),
				textFlightDate.getText(),
				textLName.getText(),
				textFName.getText(),
				textDob.getText()
			);
		} 
        catch (ParseException e1) 
        {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
	      if (thisReservation.aResult.equalsIgnoreCase("Success"))
        {
          JOptionPane.showMessageDialog(new JFrame(),
        		  	"Reservation Number: " + thisReservation.resNo,
        		  	"Success!",
        		  	JOptionPane.PLAIN_MESSAGE);
          textFlightNo.setText("");
          textFlightDate.setText("");
          textFName.setText("");
          textLName.setText("");
          textDob.setText("");
          
        }
        else
        {
          JOptionPane.showMessageDialog(new JFrame("Error!"), 
        		  thisReservation.aResult, 
        		  "Error",
        		  JOptionPane.ERROR_MESSAGE);
        }
      }
		});
      
		JPanel pane = new JPanel();
        pane.setLayout(new GridLayout(6,2,10,5));
        pane.add(labFlightNo);
        pane.add(textFlightNo);
        pane.add(labFlightDate);
        pane.add(textFlightDate);
        pane.add(labFName);
        pane.add(textFName);
        pane.add(labLName);
        pane.add(textLName);
        pane.add(labDob);
        pane.add(textDob);
        pane.add(new JLabel());
        pane.add(submitButton);
        
        return pane;
	}

    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(
                UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e) { }

        //Create the top-level container and add contents to it.
        JFrame frame = new JFrame("ReservationGui");
        ReservationGUI app = new ReservationGUI();
        Component contents = app.createComponents();
        frame.getContentPane().add(contents, BorderLayout.CENTER);

        //Finish setting up the frame, and show it.
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
        frame.pack();
        frame.setVisible(true);
    }
}

