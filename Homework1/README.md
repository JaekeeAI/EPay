
Name: Jackie Trinh
ID: 916847289
Class: ECS189e IOS Development

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

onChange
I use this to listen to changes and update whatever is in the parameter

allSatisfy and $0
I use this to check if all textfield is filled. allSatisfy is check if all element meet a certain conditions. $0 is used to check each textfield similar to loop. 

DispatchQueue.main.async
