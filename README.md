# VK ANE v0.2.0

PRO Native Extension for Adobe AIR which enables VK social network capabilities in your apps.

## Status

This demo is fully functional example. You can test ANE functions without any limitations. If you want it to be running
in your application you can purchase any number of licenses each for up to 3 applications and without any limitations in time! 
License server can be found here [http://kavolorn.ru/pro-native-extensions](http://kavolorn.ru/pro-native-extensions).

ANE supports Android-ARM, Android-x86, iPhone-ARM and iPhone-x86 including x64 bit platforms introduced in Adobe AIR SDK 16.

Extension is build with 16.0.0.259 Adobe AIR SDK, iOS 8.1 SDK, Android SDK Tools Revision 23.0.5 and Build Tools: 21.1.0.

Repository contains module file for IntelliJ IDEA.

## How to run

The most important thing to keep in mind is that this demo setup is linked with package id 'ru.kavolorn.ane.VK.Demo'.
You can only change this id in your own license key (where you can have up to 3 ids).

So let's configure this demo for your own vk application.

### Application registration process

Goto [my applications](https://vk.com/apps?act=manage) page and create your application. After the registration in
the options page you can see your vk application id. Current demo is using 4620596 and you will have your own.

On the options page fill 3 fields app bundle id for iOS, app id for iOS and android package name with value 
'ru.kavolorn.ane.VK.Demo'. When you will have your own key you can link your vk app with your own application id.

Also you should fill certificate fingerprint for Android. We will get this fingerprint directly from our extension later.

### Configuring application descriptor

Now let's apply our vk application id in application descriptor file VK_Demo-app.xml. You should change 4620596 number
with your own number in this lines for iOS setup:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
         <key>CFBundleURLSchemes</key>
        <array>
            <string>vk4620596</string>
        </array>
    </dict>
</array>
```

Add this lines if you modifying your own application descriptor.

Make sure that you have registered activities in your android manifest file:

```xml
<application android:enabled="true" android:allowClearUserData="true">
    <activity android:name="com.vk.sdk.VKOpenAuthActivity" />
    <activity android:name="ru.kavolorn.ane.activities.VKOpenAuthActivity" />
</application>
```

### ActionScript side

You can check how I use native extension in HomeScreenView.as file. It is the main file in our project.

For Android setup you can get you certificate fingerprint by calling this method:

```actionscript3
trace(VK.getInstance().getCertificateFingerprint());
```

After that you are able to put value in your vk application options page.


## Requirements

iOS 7.0+, Android 9+

## Version history

### 0.2.0

- Time limitation for license has been removed.

### 0.1.1

- Initialization bug has been fixed.

### 0.1.0

- Initial release.

