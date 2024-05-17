import cv2
import numpy as np

# Function to detect pink squares
def detect_pink_square(frame):
    # Convert frame to HSV color space
    #hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    
    # Define lower and upper bounds for pink color
    # lower_pink = np.array([140, 50, 50]) #hsv
    # upper_pink = np.array([180, 255, 255]) #HSV
    # lower_pink = np.array([180, 105, 135])  # Example values for lower bound
    # upper_pink = np.array([255, 160, 200])  # Example values for upper bound


    # lower_magenta = np.array([85, 0, 85])  # Example values for lower bound
    # upper_magenta = np.array([255, 100, 255])  # Example values for upper bound

    lower_red = np.array([0, 0, 130])  # Example values for lower bound
    upper_red = np.array([100, 100, 255])  # Example values for upper bound


    # Threshold the HSV image to get only pink colors
    mask = cv2.inRange(frame, lower_red, upper_red)
    return mask

# Main function
def main():
    # Open video capture
    cap = cv2.VideoCapture(0)
    
    while True:
        # Capture frame-by-frame
        ret, frame = cap.read()
        
        # If frame is not read correctly, continue
        if not ret:
            continue
        # Detect pink square
        mask = detect_pink_square(frame)

        
        # Find the coordinates of all 1 values
        coordinates = np.argwhere(mask == 255)

        frame = cv2.bitwise_and(frame, frame, mask=mask)

        if len(coordinates) != 0:
                

            # Calculate the mean of the coordinates along each axis (rows and columns)
            average_coordinates = np.mean(coordinates, axis=0)
            print("avg coord", int(average_coordinates[0]), int(average_coordinates[1]))
            

            cv2.circle(frame, (int(average_coordinates[1]), int(average_coordinates[0])), 5, (0, 0, 255), -1)
    
        
        cv2.imshow('Frame', frame)
        
        # Break the loop if 'q' is pressed
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        
    # When everything done, release the capture
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
