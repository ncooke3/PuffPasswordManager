
# Puff - Password Manager 🌥🔐
[![forthebadge](http://forthebadge.com/images/badges/made-with-swift.svg)](http://forthebadge.com)	[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

**Hey there!** If you're reading this, that's awesome– someone is actually looking at my repo! Woohoo! 🙌🏼 Anyway, the idea for **Puff** came from wanting to give a go at creating an iOS app. Now, technically my *first* app was [**Zen - A Meditation Timer**](https://github.com/ncooke3/Zen), but this project was too simple in the sense that I didn't walk away with a strong enough feel for what iOS development was *really* like.  Sooo, back to **Puff**! The idea is pretty simple- a password manager. The need for having a password manager seemed pretty obvious to me, someone who stores all their accounts and passwords in the native iOS *Notes* app. Yes, I know, I know,  not very secure. So, let's talk a little more about some of **Puff**'s features and how I went about implementing them. 


# Clouds, clouds, and more ☁!
One of the main goals for this project was to create the best user interface I could make. I'll admit I didn't have much of a plan when I started, but I found a theme pretty early on. I added a Lottie animation to my project and was amazed at both how simple it was to add the Lottie and how much fun it brings to a view. I can't recommend them enough, so check [them](https://github.com/airbnb/lottie-ios) out! The Lottie I added featured some animated clouds with a lock that pops in and out every few seconds. I liked it so much that I decided I would stick with the clouds theme because it felt playful, light, and airy. In retrospect, I'm glad I chose this design scheme since it offers a little fun juxtaposition to the mundane, serious nature of managing your passwords. 

## Add and Delete Accounts Like a Boss 😎

I think a password manager should have two (okay, three! 😏) main functionalities:
1. Display all your accounts
2. Add Accounts
3. And Delete Accounts (after GoT, there was no use for that HBO password anymore 😔)

## The List your Accounts Deserve

<img  src="https://media.giphy.com/media/JpY5J4HutL0Q4UfkN7/giphy.gif"  alt="Delete Feature"  title="Swipe to delete" img align="right" width="150"
/>

When it comes to remembering our passwords, we all have the *list*. It could be a stack of loose sticky notes with scribbled usernames and passwords. It might be on a piece of paper that seems to always get lost, found, and then lost again. Maybe it's a digital list like my old one (before **Puff** 😉) where it lacked both efficiency and security. 

With Puff, we have one list that keeps things simple. On the right of each UITableView cell, we have an UIImageView containing an image of the company logo. In the middle of the cell is a label with the corresponding username for the account tied to that company. 

## Adding an Account

Tapping the **+** button in the top right corner of the main view will bring the user to the add account page. As the user types in the *service* textfield, they will notice a suggestion will fill the search bar. 

The user can then fill in that account's associated username and password and press *Save*. This then brings up a temporary loading view where the user can see the progress of their account being created and stored. While the spinner is showing, network calls are being made to retrieve a URL where we can find a logo for that account's service. This `logoURL` will be used to then retrieve the actual image of the logo as a *.png* for display in the list we talked about earlier. I had a lot of fun figuring out how to make the spinners accurately represent the progress of the network calls and will share how I used some Swift threading 🧵 and concurrency to get the job done.

### Covering all possibilities!
* On the left represents the standard flow for adding an account. Here, everything just works. 🙏🏻
* The flow in the middle occurs when the user forgets to fill out one or more of the fields. I *love* that ghost! 👻
* The flow on the right represents the case where something went wrong. For 99.99% of the time, it is probably a network error that has occurred in trying to retrieve the service's url logo we mentioned earlier. 

<img src="https://media.giphy.com/media/TKuNnnvVPPKWjDhMau/giphy.gif" width="150" height="300" img align="left"><p align="center"><img src="https://media.giphy.com/media/U3I3oG7XpCHWpriHXe/giphy.gif" width="150" height="300"><img src="https://media.giphy.com/media/dZWKeaZVSEVBwnrHj8/giphy.gif" width="150" height="300" img align="right"></p>

### Spinners gonna spin
When a user adds an account, a blue spinner circle (we will call this the *loading* animation) pops up on the screen to give the user feedback of the progress of storing their account and retrieving the needed information to display it in the main list. When the task is successful, a blue check mark (we will call this the *success* animation) is presented and the view is collapsed to bring the user back to the main screen. 

Before I begin my network call, I started the loading animation.
Then, when the the network call is completed and the function's callback/completion handler is called (the network call is handled asynchronously), I needed a way to end the loading animation and present the success animation. 

The problem I encountered was that these UI updates needed to happen on the main thread of the application. Apple requires that UI updates should occur on this thread to provide the smoothest user experience. Since these updates were being triggered in an asynchronous function's callback, I needed to get creative to create a solution that satisfied this condition and avoided a bunch of nested callbacks 🔥👹 (since I still had some additional waiting to since I was designing a sequence of animations that needed to be presented synchronously). 

So when the network call works, I play one loop of the loading animation and fade it fade out. 

    func finishLoadingAnimation(durationOfLoadingAnimation) {
	    DispatchQueue.main.async { 				// this will execute the following code on the main thread!
		    loadingAnimation.pause() 			// stop the current spinning
		    loadingAnimation.play(toProgress: 1)// play it one time through
		    loadingAnimation.loopMode = .playOnce
		    
		    UIView.animate(withDuration: durationOfLoadingAnimation, animations: {
			    
		    }, completion: (_) in {
			    loadingAnimation.removeFromSuperview()
				loadingAnimation.removeConstraints(loadingAnimationConstraints)
				loadingAnimation.alpha = 1 // resets it to 1 for next time!
		    })
	    }
    }

The trick was using `DispatchQueue.main.async {}` to execute that code in the main thread since this function will be called in the completion handler to in `fetchCompanyData()` function. 

Next we need to start and finish the process with our success animation. This function is called directly after after the one above, but the animations still happen sequentially... *how*? 🧐

The trick lies in using `DispatchQueue.main.asyncAfter()` this time around! By passing in the duration of the `loadingAnimation`, that block of code handling the `successAnimation` will run after the waiting the same time as it takes for the `loadingAnimation` to finish! 


	func finishSuccessAnimation(loadingDurationInSeconds: TimeInterval, completion: @escaping () -> ()) {

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + loadingDurationInSeconds, execute: {

			setupSuccessAnimation()

			successAnimation.play() { (_) in

				UIView.animate(withDuration: 0.3, animations: {

					successAnimation.alpha = 0

					animateLightBlurViewOut()

				}, completion: { (_) in

					successAnimation.removeFromSuperview()

					successAnimation.removeConstraints(successAnimation.constraints)

					successAnimation.alpha = 1

					completion()

				})

			}

		})

	}


I applied the same technique when presenting the `errorAnimation`. 
I felt this was a pretty reusable solution to cleaning up the code for running animations (specifically, animations like Lotties which aren't like the animations done using the native animation libraries) continuously. 



## Delete an Account
<img  src="https://media.giphy.com/media/VCQ8GDqf1iql2HidyU/giphy.gif"  alt="Delete Feature"  title="Swipe to delete" img align="right" width="150"
/>

Deleting 🚮 an account is simple and easy! Swipe left to reveal a red circle with a trashcan. Tap on the red delete button to delete the account. Behind the scenes, the account's *password* is removed from iOS Keychain and then the entire account is removed from the list of user accounts. 

This feature was implemented using  [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit)! It's an awesome library as all I needed to do was set the `delegate` property on an `AccountCell` (which subclassed `SwipeTableCell`– a class in the library) and then adopt the `SwipeTableViewCellDelegate`! It definitely can help if you desire a more "natively iOS cell swipe experience" as well so check it out! 🥳

Last, if the deleted account's service (i.e. Twitter) is not shared by another account (i.e. the user has multiple Twitter accounts saved), then the company will be removed from our dictionary containing the company names and their corresponding information. We will discuss this data structure in a bit!


## Edit an Account
<img src="https://media.giphy.com/media/KYh0JTYjn576JT4ScU/giphy.gif"  alt="Delete Feature"  title="Swipe to delete" img align="right" width="150"/>

Okay, okay... I might have lied about a password manager only needing three functionalities. The ability to edit an account isn't exactly necessary as you could always delete an account, say your Netflix account, and add it back with an updated password. But we are in the business of making our users' lives *easier*, so I added a view when the user taps on a cell that allows for viewing the account's information and updating the password. 

For both the displayed *username* and *password*, I added little copy buttons next to each label, respectively. Tapping on a button copies the content in the textfield it corresponds to. This saves the user the hassle from flipping back and forth between **Puff** and the app where they are trying to login into the account. 


# But is it secure?

Good question! The answer is yes, sorta. I'd like to go ahead and admit I'm not a security expert and I'm sure things might get hairy if your unlocked phone found its way into the hands of a villainous hacker 🦹‍♂️. 

But, moving on, the way I decided to store the user's accounts is really the *crux* of the app. Everything else is just giving the user the ability to interact with this data. I designed it like this:

- Each account is represented by an instance of an `Account` class. This `Account` class conforms to `Codable`, which, per the [Apple docs](https://developer.apple.com/documentation/swift/codable) is:
	> a type alias for the `Encodable` and `Decodable` protocols

	Basically, this means that an instance of the class can be encoded and decoded into an external representation like JSON. For reference, [this](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) article was amazing at helping me understand the concept.

- The `Account` class has several properties. Let's focus on the `service`, `username`, and `password` properties. Let's say we have a *Spotify* account where our username is *lilUzi4eva* and our password is *we<3cats*. 
- The most important piece of information we need to securely store is our user's `password`. I chose to store it in iOS's [Keychain](https://developer.apple.com/documentation/security/keychain_services). The instance of the `Account` class that the `password` is a property of sort of "points" to that secure chunk of memory Apple's keychain. I used Mathew Palmer's ***awesome*** [Locksmith](https://github.com/matthewpalmer/Locksmith) library to work with keychain. Setup was pretty easy after I figured it out. I needed to conform my `Account` class to some specific protocols in the Locksmith library and write up my own methods to properly store, retrieve, modify, and delete data stored in keychain. 

	One quirky think I learned was that after storing something in Keychain on your personal phone, you can't really delete it unless you factory reset your phone. If running your app on the Xcode simulator, you can easily wipe the phone, but since I tested most of **Puff** on my personal iPhone, I definitely have some random account passwords floating in my device's memory that I added when I didn't yet have a way to properly delete them. 😂 Users won't have this persisting data issue since I designed the delete account flow to properly remove the account's password from the device's keychain! 👍🏼

- *Anyways*, we have each user stored account represented by an instance of the `Account` class. The `password` property of the object is stored in keychain. So now we know how we stored a single account, but obviously the user is expected to store multiple accounts right? And, how will the list of accounts persist between app launches? The answer is Apple's [User Defaults](https://developer.apple.com/documentation/foundation/userdefaults) API which, per the docs is explained as:
	>An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.

	I chose to collectively group all of the `Account` objects a user creates in an array that was stored in *UserDefaults* This backing array was the *value* to a *key* used to reference it. The *key* I chose was simply `"accountsKey"`. This array object was represented by my `AccountsDefaults` struct. 

	Remember how we discussed that each `Account` class conforms to `Codable` above? Welp, this is why! 💡 🧠 When your iPhone uses UserDefaults to make data persist, it needs to effectively condense the data you wish it to store into a predictable, easy to work with form. In the case of UserDefaults, data is stored in a [property list](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/PropertyList.html). 
* So this pretty much wraps up how I kept track of all of the accounts a user adds. We have an array of `Account` instances where each instances's `password` property is stored in iOS Keychain for security and the entire array itself is stored in UserDefaults to persist between launches. 

### But how did we keep track of the companies? 
To keep it short, I also stored a dictionary `companies =[String: Company]` in UserDefaults represented by `struct CompanyDefaults{}` that kept track of the companies associated with the user's accounts. Each `Account`'s `service` property (i.e. *Netflix*, *Spotify*, or *Hulu*) doubled as a key in in `companies`. So when the user adds an account, network calls are made to retrieve a url where we can retrieve the logo for that respective company. The logo url's are stored in the individual `Company` objects. On the main view with our accounts list,  I used [SDWebImage](https://github.com/SDWebImage/SDWebImage) to retrieve the logo image for each cell. 

## Lessons learned...💡
This was definitely my biggest personal project to date and I'm pretty proud of how it turned out. While my app isn't as *perfect* or as *robust* as some other password managers out there, it is still a great alternative to listing all of your accounts in the *Notes* app or jotting them down on sticky notes (only to get lost 🤦🏻‍♂️....). Plus, the *real* goal with **Puff** was to learn the fundamentals of iOS development. I definitely learned a lot about:
- ✅ Laying out a UI 
- ✅ Data fetching 
- ✅ Persistent data storage
- ✅ Secure data storage 
- ✅ Local authentication (FaceID/TouchID/passcode)
- ✅ Animations/Transitions

I also became fairly comfortable with Swift and some of its features like:
- ✅ Optionals
- ✅ Error Handling
- ✅ Completion handlers
- ✅ Threading & Concurrency
- ✅ Structs vs. Classes
- ✅ Delegates
- ✅ View Lifecycles

I think my biggest realization was just *how much* effort has to go into to creating a great piece of software. The designing, architecting, implementing, and testing are no joke! It takes **a lot** of time and it is easy to get discouraged along the way, especially if you are learning everything for the first time like I was on this journey. 

I felt I walked away from this project with a solid sense of what mobile development is like...and I realized I enjoy working with iOS and making apps! 🍎  I definitely want to make another app that's even ~cooler~ ^and^~funner~ 😅. I also want to get much better at user interface design so I've started to practice that as well. 

If you made it this far, thank you so much! **Puff** is now available on the Apple App Store!

## Awesome Frameworks That I Used

* [Locksmith 🔐](https://github.com/matthewpalmer/Locksmith)
* [Lottie 🎢](https://github.com/airbnb/lottie-ios)
* [SwipeCellKit ⬅](https://github.com/SwipeCellKit/SwipeCellKit)
* [UIImageColors 🎨](https://github.com/jathu/UIImageColors)
* [SDWebImage 📸](https://github.com/SDWebImage/SDWebImage)
* [SwiftyJSON 😎](https://github.com/SwiftyJSON/SwiftyJSON)


## My attempt at a privacy policy

I, the developer of **Puff**, do not have access to any of the information you enter into **Puff**. All of that information is stored on your iPhone (peep 👀 the source code for proof!). This being said, I am not responsible for your data being compromised should your phone fall into the hands of someone with malicious intents. If you leave your phone unlocked and your cat logs into **Puff** and changes your Netflix account's password, welp, that's on you! (I would also get rid of that cat ASAP!) The passwords you do store are stored in iOS keychain which we can think of as a black box of security stuff that Apple meticulously designed that I can't really explain. But bottom line, this is just a project by a college student so think responsibly and, most importantly, don't sue me! (Seriously, the college budget does not cover a lawsuit's associated legal fees! 😅)
