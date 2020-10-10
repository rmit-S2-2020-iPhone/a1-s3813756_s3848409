# Assigment 2 COSC2472
a1-s3813756_s3848409 created by GitHub Classroom

### Team member:
1. Sokleng Lim (s3813756)
2. Monkolsophearith Prum (s3848409)

## Expense Tracker App
Expense Tracker is an app build for people who are looking to track their expenses on daily basis so they can cutdown and limit their non-neccessary expenses with a monthly budget while they can also browse through their expense history and see the statistics on a pie chart as well. For user's comfortable experience, this app allow user to change their name and set their profile picture too. Expense Tracker is built using storyboard with Swift 4 on Xcode 10.3. The deployment target iOS is currently 12.4. This app can be deployed on the latest iOS as well. For information on how to deploy the app, please see instructions below. 

### Deployment Information

1. Download or Clone the app from GitHub repository.
2. Have your Xcode 10.3 or Xcode 11 ready.
3. Open the app workspace from the project directory
4. Open a terminal and go to the root project directory.
5. Install cocoapods using the following commands
  
  ```
  sudo gem install cocoapods
  ```
  
  ```
  pod init
  ```

6. Then add ``` pod 'Charts', '~> 3.1.0' ``` , ``` pod 'PKHUD', '~> 5.0' ``` and ``` pod 'ALCameraViewController' ``` the pod file as below
  
  ```
  target 'MyApp' do
    pod 'Charts','~> 3.1.0'
    pod 'PKHUD', '~> 5.0' 
    pod 'ALCameraViewController'
  end
  ```
7. Install the required Pod for "Pie Chart"

  ```
  pod install
  ```

8. Set the project settings to match with your Xcode preferences such as ```iOS target deployment```, ```Code Sign In Identity```, etc
9. Choose your preferred simulator to run the project on, iPhone XR or iPhone XS Max is recommended.
10. Build the Project from Xcode
11. Then you should be able to see the app on your iOS simulator

### Clean Up Instruction

1. To clean up, just stop the build
2. Quit the simulator
3. Then you should be good to go
  
