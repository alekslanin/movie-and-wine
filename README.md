# wineandmovie

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## tools

rbenv (brew install rbenv ruby-build)
ruby 3.1+ // which ruby. PATH must point to /Users/aleksandrlanin/.rbenv/versions/4.0.0 (rbenv install 4.0.0; rbenv global 4.0.0)    
nvm
node.js and npm (nvm install node; rbenv global 4.0.0)
cocoapods (sudo gem install cocoapods)

extension: Open Xcode Project

## Create project and initialize firebase

npm install -g firebase-tools

flutter create wineandmovie --org app.wam

firebase login 

firebase project:list

dart pub global activate flutterfire_cli

flutter pub add firebase-core 

flutterfire configure --project=wine-and-movie
    Platform  Firebase App Id
    android   1:1010176194732:android:91afc267098340ef634709
    ios       1:1010176194732:ios:f0bf952528b82d2e634709

firebase init emulators 

firebase emulators:start --only auth

ios -> Runner -> GoogleService-Info.plist (load from firebase console)
android -> src -> google-services.json (same)


pub/sub: https://www.youtube.com/watch?v=vR2q7at97Cs
https://github.com/BohdanSamusko/flutter_firebase_messaging

create apple keys (APN key) in apple DEVELOPER web site
download key
https://developer.apple.com/help/account/keys/create-a-private-key

Note: release in app STORE CONNECT

## packages

* flutter pub add flutter_riverpod
* flutter pub add go_router
* flutter pub add json_serializable

# flutter
flutter pub upgrade --major-versions
flutter clean
flutter run

The command flutter run --release compiles to release mode. Your IDE supports this mode. Android Studio, for example, provides a Run > Run... menu option, as well as a triangular green run button icon on the project page. You can compile to release mode for a specific target with flutter build <target>. For a list of supported targets, use flutter help build.

flutter build <build-target> \
   --obfuscate \
   --split-debug-info=/<symbols-directory>

BUILD-TARGET :: ipa for apple and appbundle for android

To DEPLOY on Android : drag and drop into google play console 
To DEPLOY on IOS : use Transporter app. Drag and drop ipa file into Transporter, then deliver it. App will be available in the Test Flight 


## obfuscate dart code
https://docs.flutter.dev/deployment/obfuscate

# Error: CocoaPods's specs repository is too out-of-date to satisfy dependencies. To update the CocoaPods specs, run: pod repo update
cd  ios
pod repo update
rebuild app

or/and

cd ios
delete podfile.lock
pod repo remove trunk
run pod install or pod install --repo-update




## TODO

### Prod vs Non-prod environments
https://github.com/Chijama/flutter-engineering-by-chapter/tree/main/chapter_17_environments_and_flavors
InheritedWidget
Singleton
dart-define

### read about Flutter mixins

### login with google credentials
add google_sign_in package


## Riverpod
set Provider Scope

### easy level
create StateProvider

StatelessWidget => ConsumerWidget
Widget build(BuildContext context)  => Widget build(BuildContext context, WidgetRef ref)
 
ref.watch(riverpod)
ref.read(riverpod.notifier).state

### hard level
create Model which extends ChangeNotifier
model call notifyListeners
create: ChangeNotifierProvider<Model>

StatelessWidget => ConsumerWidget
Widget build(BuildContext context)  => Widget build(BuildContext context, WidgetRef ref)

ref.watch(riverpod).name
ref.read(riverpod).chamgeName(newValue: value)



Apple Push Notifications

create profile add device UDID(s) to profile

create APNs key

    Name:push notification
    Key ID:6ZZQY329FC
    Services:Apple Push Notifications service (APNs)

open xCode add Push Notification and Backgroud Mode (select Background fetch and Remove notification) capabilities


Name:APNS Push Notifications
Key ID:G56A9SX83D
Services:Apple Push Notifications service (APNs)

