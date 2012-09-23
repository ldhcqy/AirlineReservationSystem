import java.awt.*;
import javax.swing.*;

import java.awt.event.*;

/**
 * ReserveSeatGUI.java - creates GUI to enter date to reserve seat
 * @author Sarah Heredia
 * @version 12/09/2011
 */
public class ReserveSeatGUI 
{
	private AssignSeat thisSeat;

	public Component createComponents() {
        
		// Labels
		final JLabel 
			labResNo 	= new JLabel("Reservation Number"),
			labSeatNum	= new JLabel("Seat Number");
		
		// Text Fields
		final JTextField
			textResNo 	= new JTextField(),
			textSeatNum	= new JTextField();
		
		// Button and listener
		final JButton submitButton = new JButton("Submit");
		submitButton.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) 
        {
        	int res = Integer.parseInt(textResNo.getText());
        	thisSeat = new AssignSeat
        	(
        		res,
        		textSeatNum.getText()
        	);
        	if (thisSeat.aResult.equalsIgnoreCase("Success"))
        	{
        		JOptionPane.showMessageDialog(new JFrame(),
            		  	"Seat Booked!",
            		  	"Success!",
            		  	JOptionPane.PLAIN_MESSAGE);
        		textResNo.setText("");
        		textSeatNum.setText("");
        	}
        	else
        	{
        		JOptionPane.showMessageDialog(new JFrame("Error!"), 
              		  thisSeat.aResult, 
              		  "Error",
              		  JOptionPane.ERROR_MESSAGE);
        	}
        	
        }
		});
       

		JPanel pane = new JPanel();
        pane.setLayout(new GridLayout(3,2,10,5));
       
        pane.add(labResNo);
        pane.add(textResNo);
        pane.add(labSeatNum);
        pane.add(textSeatNum);
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
        JFrame frame = new JFrame("Seat Chooser");
        ReserveSeatGUI app = new ReserveSeatGUI();
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
