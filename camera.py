import cv2 as cv
from cvzone.HandTrackingModule import HandDetector

capture = cv.VideoCapture(0)
detector = HandDetector(detectionCon=.7, maxHands=1)


while True:
    ret, frame = capture.read()
    hands, frame = detector.findHands(frame)

    if hands:
        fingers = detector.fingersUp(hands[0])
        
        if fingers == [0, 0, 0, 0, 0]:
            print("fist")
            cv.putText(frame, "Fist", (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        else:
            print("not a fist")

    cv.imshow("Camera", frame)

    if cv.waitKey(1) & 0xFF == ord("q"):
        break

capture.release()
