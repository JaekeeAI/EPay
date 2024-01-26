
Name: Jackie Trinh
ID: 916847289
Class: ECS189e IOS Development

- HW1 - 

DefaultPhoneNumberTextField
A subclass of PhoneNumberTextField from the PhoneNumberKit framework.
I use it to overrides the defaultRegion property to set the default region to "US".

Coordinator
I use it to bridge user interactions from the UIKit text field to the SwiftUI view. When textfield updates it will send back the info to SwiftUI

GeometryReader
Grab the size of parent view and adjust the location of the button to the bottom of the screen

ignoreSafeArea(.keyboard)
I use this to prevent the keyboard pop up from moving the View up

disabled(!viewModel.isPhoneNumberValid)
I use this to disable the button so users can't click on it if number is invalid

PhoneNumberTextFieldWrapper
A struct conforming to UIViewRepresentable to bridge the UIKit-based DefaultPhoneNumberTextField into SwiftUI.
Utilizes a @Binding variable to bind text input from the UIKit component to the SwiftUI view.
Manages the creation and update of the UIKit view.
Implements a Coordinator class for handling text field events and communicating them back to SwiftUI.

- HW2 - 

allSatisfy and $0
I use this to check if all textfield is filled. allSatisfy is check if all element meet a certain conditions. 
$0 is short hand notation of for loop, I used to check each textfield similar to loop. 

DispatchQueue.main.async
I receive an error "Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates." I found a way to solve it on stack overflow. 

Circular Loading & Animation 
Here a website I references from to create the circulat spinning animation
https://medium.com/@ganeshrajugalla/creating-beautiful-custom-loaders-with-swiftui-4ca99f3591b4

DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {}
I used this code to delay 1 second before transitioned to home view. Here a link where I learn the code
https://www.hackingwithswift.com/example-code/system/how-to-run-code-after-a-delay-using-asyncafter-and-perform

Timer.scheduledTimer
I got rate limited for sending too many multiple OTP request so I set up a cooldown using a Timer 
