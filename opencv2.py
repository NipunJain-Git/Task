import cv2

cap = cv2.VideoCapture(0)

previous_x = None
previous_y = None


while True:
	ret, frame = cap.read()
	if not ret:
		break;
	
	hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
	
	l_blue = (100, 150, 50)
	u_blue = (140, 255, 255)
	
	mask = cv2.inRange(hsv, l_blue, u_blue)
	#cv2.imshow("Mask", mask)
	#cv2.imshow("Frame", frame)
	
	contours, hierarchy = cv2.findContours(
		mask,
		cv2.RETR_EXTERNAL,
		cv2.CHAIN_APPROX_SIMPLE
	)
	
	if contours:
		largest_contour = max(contours, key=cv2.contourArea)
		
		if cv2.contourArea(largest_contour) > 500:
			x, y, w, h = cv2.boundingRect(largest_contour)
			
			cv2.rectangle(
				frame, 
				(x, y),
				(x + w, y+h),
				(255, 0, 0),
				2				
			)
			center_x = x + w // 2
			center_y = y + h // 2
			
			cv2.circle(
				frame,
				(center_x, center_y),
				5,
				(0, 0, 255),
				-1
			)
			
			if previous_x is None:
				direction = "Stationary"
			else:
				dx = center_x - previous_x
				dy = center_y - previous_y
				
				if abs(dx) < 10 and abs(dy) < 10:
					direction = "Statonary"
					
				elif abs(dx) > abs(dy):
					if dx>0:
						direction = "right"
					else:
						direction = "left"
				else:
					if dy > 0:
						direction = "Down"
					else:
						direction = "up"
			cv2.putText(
				frame,
				f"Direction: {direction}",
				(x, y + h + 25),
				cv2.FONT_HERSHEY_SIMPLEX,
				0.6,
				(255, 255, 255),
				2				
			)
			print(
				f"Center: ({center_x},{center_y}) | "
				f"Direction: {direction}"
			)
			
			previous_x = center_x
			previous_y = center_y
			
	cv2.imshow("Color based object tracking", frame)
	cv2.imshow("Mask", mask)
	
	if cv2.waitKey(1) & 0xFF == ord ('q'):
		break
cap.release()
cv2.destroyAllWindows()
