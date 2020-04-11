# Android

The Android version acts the same way as the iOS version.

Please keep in mind these are my first projects on Swift and Android, so if there are code design or architecture flaws, issue it on GH.

### Important Adjustments

Because I despise Android development, I didn't follow any architectural rules. The networking is a bit wonky with a bunch of XML values that I had to add for local development.

What you need to do is go to `server/server/settings.py` and change `192.168.0.12` to your private IP address.
- You can find it out by typing `ifconfig` for Linux or MacOS or `ipconfig` on Windows in your terminal/cmd

You also need to go to `res/xml/network_security_config` and for Kotlin `com.andrewcwang.jwtauth.networking.AuthService` and change the IP addresses there too.

The values I've added in Android's manifest:
- android:networkSecurityConfig="@xml/network_security_config"
    - You should also delete that XML file, as well, when going into production
- This monstrosity:
```
<service android:name="com.andrewcwang.jwtauth.GenericAccountService">
    <intent-filter>
        <action android:name="android.accounts.AccountAuthenticator" />
    </intent-filter>
    <meta-data android:name="android.accounts.AccountAuthenticator" android:resource="@xml/authenticator" />
</service>
```
You should just use Firebase or Google's Suggested Smart Lock. I'm using this for convenience and because Google can't make up their minds with how to run the show... Too many options makes me confused...

### Tech stack

- Android: minSdkVersion 22, Target 29 using Kotlin 1.3.70
- Retrofit 2.7.2 + Moshi Retrofit Converter
- Kotlin Moshi 1.9.2 (I used Moshi after analyzing previous experiences online including top contributors of Gson + Moshi. Moshi, in the long run, is the way to go for any app, Kotlin or Java heavy, as you scale up)
- OkHTTP Logging Interceptor 4.2.2

### How does it work

The Android version acts the same way as the iOS version.

I'm following Google's GOD rule for one-activity-multiple-fragment architecture.

When a user needs to log in again, since I'm using the one activity multiple fragment methodology, the fragment calls the activity method for logging in again. To know when this happens, unwrap the `Response`.

The iOS version requires a network abstraction layer since I didn't want to add dependencies. For Android, however, the community rallies around Retrofit, and, being a beginner in Android development (all frontend is new to me), I've decided to stick with the pack this time. Additionally, Android revolves around Google. I don't own an Android for a reason. All authentication service has some tying connection with Google accounts that you must have for Google Play Service.

It's also worth mentioning that the networking acts a little differently in Android from iOS. In iOS, it's not recommended you stick with a singleton network manager (the `session.shared` is already a singleton). Here, Retrofit has everything ready plus, the way Android apps are designed, makes the "AuthModel" easier to understand.

I'll be using Kotlin 1.3.70 since it's close to Swift syntax.

### Extra Notes

PLEASE DO iOS development first and deploy your web app FIRST. Android local development is a pain in the bum... Just trust me and you can ignore some of those aforementioned weird XML stuff and just use your regular domain.

What I like about Android development being slightly proficient in Swift now is that Kotlin's syntax is closely related to Swift's. Additionally, I've worked with JetBrain products before and their autocomplete feature on here is amazing when it comes to imports.

What do I not like about Android development in comparison with iOS development?

In iOS, all the UI configuration along with business logic are systematic: I only need to know one component to complete the entire app.

Although I first began Android development when first learning Java a couple years ago (also not being able to run the simulator was great), Android has several different components that I need to go back and forth on. XML files are separated from the Java files, physically -- yes, and that's just kinda annoying to deal with; I like how, in Swift, I can set my NSLayoutConstraints and know what I'm getting immediately. A nice plus for Android though is the simplicity of XML and automatically being able to see the outcome without needing to compile. The other hard part is having the directories be static. I like creating my own workflow and playing around with structure hierarchy is a +.

This isn't to rip off Android. Developing with any language for any framework is fun and great, but the lack of fluidity when it comes to this development doesn't make me the happiest person.

(Story: When I first tried Android dev as a Freshman in High School, I couldn't take fragments. They were the reason why I quit after 2 months :)
