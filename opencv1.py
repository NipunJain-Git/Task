import cv2 
import numpy as np

aruco = cv2.aruco
aruco_dictionary = aruco.getPredefinedDictionary(aruco.DICT_4X4_50)

parameters = aruco.DetectorParameters()
detector = aruco.ArucoDetector(aruco_dictionary, parameters)

cap = cv2.VideoCapture(0)
if not cap.isOpened():
	print("Camera not opened")
	exit()
	
while True:
	ret, frame = cap.read()
	if not ret:
		print("could not read frame")
		break
	corners, ids, rejected = detector.detectMarkers(frame)
	
	if ids is not None:
		aruco.drawDetectedMarkers(frame, corners)
		
		for i in range(len(ids)):
			marker_id = int(ids[i])
			marker_corners = corners[i][0]
			
			center_x = int(np.mean(marker_corners[:, 0]))
			center_y = int(np.mean(marker_corners[:, 1]))
			
			cv2.circle(
				frame, 
				(center_x, center_y), 
				5, 
				(0,0,255), 
				-1
			)
			
			cv2.putText(
				frame, 
				f"ID: {marker_id}", 
				(center_x - 40, center_y - 20),
				cv2.FONT_HERSHEY_SIMPLEX, 
				0.6, 
				(0, 255, 0), 
				2
			)
			
			cv.putText(
				frame, 
				f"Center: ({center_x}, {center_y})", 
				(center_x - 80, center_y + 30),
				cv2.FONT_HERSHEY_SIMPLEX, 
				0.5, 
				(0, 255, 0), 
				2
			)
			
			print(f"Marker ID: {marker_id}")
			print(f"Center: ({center_x}, {center_y})")
		
	cv2.imshow("Aruco Marker Detection", frame)
	
	if cv2.waitKey(1) & 0xFF == ord('q'):
		break

cap.release()
cv2.destroyAllWindows()
print("Detection stopped")
