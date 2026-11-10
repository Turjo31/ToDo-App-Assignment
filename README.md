# ToDoApp (SwiftUI + Firebase Auth + Firestore)

## WHERE TO CHANGE FOR FIREBASE AUTHENTICATION
There is NO Swift code to edit. Only four things connect this app to your Firebase:

1. **GoogleService-Info.plist**
   Firebase console > Project settings > Your apps > iOS app > download it.
   Drag it into the Xcode project (tick "Copy items if needed" and your app target).
   This file holds your project ID and API key.
2. **Bundle ID**
   Xcode > project > target > Signing & Capabilities > Bundle Identifier
   must be EXACTLY the one you typed when registering the iOS app in Firebase.
3. **Enable Email/Password sign-in**
   Firebase console > Build > Authentication > Sign-in method > Email/Password > Enable.
4. **Firestore rules**
   Firebase console > Build > Firestore Database > Rules > paste `firestore.rules` > Publish.

(`FirebaseApp.configure()` in ToDoAppApp.swift is what reads the plist.)

## At the Mac lab
1. Xcode > File > New > Project > iOS > App. Interface: SwiftUI, Language: Swift.
   Product name: ToDoApp. Set your Bundle ID.
2. File > Add Package Dependencies > https://github.com/firebase/firebase-ios-sdk
   Add: FirebaseAuth, FirebaseFirestore (FirebaseCore comes with them).
3. Delete the generated ToDoAppApp.swift and ContentView.swift.
4. Drag the Models, Services, Views folders and ToDoAppApp.swift into the project.
   Drag in GoogleService-Info.plist.
5. Pick an iPhone simulator, press Cmd+R.
