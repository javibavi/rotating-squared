import cv2 as cv # importing opencv 
from cvzone.HandTrackingModule import HandDetector # importing the hand detector from cvzone
import socket
import time

UDP_PORT = 6789
COOLDOWN = 0.1
capture = cv.VideoCapture(0) # Sets
detector = HandDetector(detectionCon=.7, maxHands=1)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
last_gesture_time = 0

def send(gesture):
    global last_gesture_time
    if time.time() - last_gesture_time < COOLDOWN:
        return
    sock.sendto(gesture.encode(), ('127.0.0.1', UDP_PORT))
    print(f"P1 → {gesture}")
    last_gesture_time = time.time()


while True:
    ret, frame = capture.read()
    hands, frame = detector.findHands(frame)

    if hands:
        fingers = detector.fingersUp(hands[0])
        
        count = 0
        for finger in fingers:
            if finger == 1:
                count+=1

        if count == 5:
            cv.putText(frame, "Open hand", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            send("right")
        elif count >= 3:
            cv.putText(frame, "Most fingers", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            send("None")
        elif count > 0:
            cv.putText(frame, "Few fingers", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            send("None")
        else:
            cv.putText(frame, "Fist", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            send("left")

    cv.imshow("Camera", frame)

    if cv.waitKey(1) & 0xFF == ord("q"):
        break

capture.release()
