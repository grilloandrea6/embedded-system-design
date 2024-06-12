In the code zip file there are:
 - arduino code using for testing the servo motors.
 - opencv code for validating our algorithm.
 - virtual prototype.
  
In the virtual prototype there are:
 - in the modules/camera/verilog directory the original camera file is saved as camera_orig.v, and our custom version is camera_project.v. camera.v is a symlink to easily switch between the 2 versions.
 - in modules/pwm_generator there is the code of the pwm generator custom module.
 - in programms/objectDetection there is the code for the software solution of the object detection.
 - in programms/project there is the code of the final accelerated version.
 - in programms/pwmGeneratorTest there is a test code for the pwmGenerator module.