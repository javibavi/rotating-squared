
import cv2 as cv # importing opencv 
from cvzone.HandTrackingModule import HandDetector # importing the hand detector from cvzone


capture = cv.VideoCapture(0) # Sets up an instance of VideoCapture from the main webcam of the computer
detector = HandDetector(detectionCon=.7, maxHands=1) # Create a hand detector object that requires a confidence of 70% and detects at max 1 hand

while True:


    # Capture every single frame and unpack it as a tuple
    ret, frame = capture.read()
    # Pass the frame we are currently on to the detector and return a list of hands as well as a frame that marks where the hands are
    hands, frame = detector.findHands(frame)

    # If we find hands 
    if hands:

        # Save the fingers of the first (and technically only) hand that the camera sees
        # fingers is an array of length 5 that tells you which fingers are up and which are down:
        # fingers = [1, 0, 0, 0, 0] -> This tells us there is a thumbs up
        fingers = detector.fingersUp(hands[0])
        
        count = 0
        # Iterate through the fingers and see how many fingers are up
        for finger in fingers:
            if finger == 1:
                count+=1

        # Based on the number of fingers, we perform a certain action and add a marking to the frame
        if count == 5:
            cv.putText(frame, "Open hand", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        elif count >= 3:
            cv.putText(frame, "Most fingers", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        elif count > 0:
            cv.putText(frame, "Few fingers", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        else:
            cv.putText(frame, "Fist", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    # Show camera frame as a window
    cv.imshow("Camera", frame)

    # Keep running the program until "q" is pressed
    if cv.waitKey(1) & 0xFF == ord("q"):
        break

# Release the video
capture.release()
