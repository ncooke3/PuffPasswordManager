# Puff - Password Manager 🌥🔐
[![forthebadge](http://forthebadge.com/images/badges/made-with-swift.svg)](http://forthebadge.com)

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

Hey there! If you're reading this, that's awesome– someone is actually looking at my repo! Woohoo! 🙌🏼 Anyway, the idea for **Puff** came from wanting to give a go at creating an iOS app. Now, technically my *first* app was [**Zen - A Meditation Timer**](https://github.com/ncooke3/Zen), but this project was too simple in the sense that I didn't walk away with a strong enough feel for what iOS development was *really* like.  Sooo, back to **Puff**! The idea is pretty simple- a password manager. The need for having a password manager seemed pretty obvious to me, someone who stores all their accounts and passwords in the native iOS *Notes* app. Yes, I know, I know,  not very secure. So, let's talk a little more about some of **Puff**'s features and how I went about implementing them. 


# Clouds, clouds, and more clouds!
One of the main goals for this project was to create the best user interface I could make. I'll admit I didn't have much of a plan when I started, but I found a theme pretty early on. I added a Lottie animation to my project and was amazed at both how simple it was to add the Lottie and how much fun it brings to a view. I can't recommend them enough, so check [them](https://github.com/airbnb/lottie-ios) out! The Lottie I added featured some animated clouds with a lock that pops in and out every few seconds. I liked it so much that I decided I would stick with the clouds theme because it felt playful, light, and airy. In retrospect, I'm glad I chose this design scheme since it offers a little fun juxtaposition to the mundane, serious nature of managing your passwords. 

## Add and Delete Accounts Like a Boss 😎

I think a password manager should have two (okay, three! 😏) main functionalities:
1. Display all your accounts
2. Add Accounts
3. And Delete Accounts (after GoT, there was no use for that HBO password anymore 😔)

## The List your Accounts Deserve

<img  src="https://media.giphy.com/media/JpY5J4HutL0Q4UfkN7/giphy.gif"  alt="Delete Feature"  title="Swipe to delete" img align="right" width="100"
/>

When it comes to remembering our passwords, we all have the *list*. It could be a stack of loose sticky notes with scribbled usernames and passwords. It might be on a piece of paper that seems to always get lost, found, and then lost again. Maybe it's a digital list like my old one (before **Puff** 😉) where it lacked both efficiency and security. 

With Puff, we have one list that keeps things simple. On the right of each UITableView cell, we have an UIImageView containing an image of the company logo. In the middle of the cell is a label with the corresponding username for the account tied to that company. 

## Adding an Account

Tapping the **+** button in the top right corner of the main view will bring the user to the add account page. As the user types in the *service* textfield, they will notice a suggestion will fill the search bar. 

The user can then fill in that account's associated username and password and press *Save*. This then brings up a temporary loading view where the user can see the progress of their account being created and stored. While the spinner is showing, network calls are being made to retrieve a URL where we can find a logo for that account's service. This `logoURL` will be used to then retrieve the actual image of the logo as a *.png* for display in the list we talked about earlier. I had a lot of fun figuring out how to make the spinners accurately represent the progress of the network calls and will share how I used some Swift threading 🧵 and concurrency to get the job done.

### A Custom Suggestion Textfield
More coming soon! 👀

### Spinners gonna spin
More coming soon! 👀

## Delete an Account

<img  src="https://media.giphy.com/media/VCQ8GDqf1iql2HidyU/giphy.gif"  alt="Delete Feature"  title="Swipe to delete" img align="right" width="100"
/>

Deleting 🚮 an account is simple and easy! Swipe left to reveal a red circle with a trashcan. Tap on the red delete button to delete the account. Behind the scenes, the account's *password* is removed from iOS Keychain and then the entire account is removed from the list of user accounts. 


## Edit an Account

Okay, okay... I might have lied about a password manager only needing three functionalities. The ability to edit an account isn't exactly necessary as you could always delete an account, say your Netflix account, and add it back with an updated password. But we are in the business of making our users' lives *easier*, so I added a view when the user taps on a cell that allows for viewing the account's information and updating the password. 

[Pictures will go here! 👀]

For both the displayed *username* and *password*, I added little copy buttons next to each label, respectively. Tapping on a button copies the content in the textfield it corresponds to. This saves the user the hassle from flipping back and forth between **Puff** and the app where they are trying to login into the account. 


# But is it secure?

Good question! The answer is yes, sorta. I'd like to go ahead and admit I'm not a security expert and I'm sure things might get hairy if your unlocked phone found its way into the hands of a villainous hacker 🦹‍♂️. 

But, moving on, the way I decided to store the user's accounts is really the *crux* of the app. Everything else is just giving the user the ability to interact with this data. I designed it like this:

- Each account is represented by an instance of an `Account` class. This `Account` class conforms to `Codable`, which, per the [Apple docs](https://developer.apple.com/documentation/swift/codable) is:
	> a type alias for the `Encodable` and `Decodable` protocols

	Basically, this means that an instance of the class can be encoded and decoded into an external representation like JSON. For reference, [this](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) article was amazing at helping me understand the concept.

- The `Account` class has several properties. Let's focus on the `service`, `username`, and `password` properties. Let's say we have a *Spotify* account where our username is *lilUzi4eva* and our password is *we<3cats*. 
- 

## Lessons learned...💡
More coming soon! 👀

## Awesome Frameworks That I Used

* [Locksmith 🔐](https://github.com/matthewpalmer/Locksmith)
* [Lottie 🎢](https://github.com/airbnb/lottie-ios)
* [SwipeCellKit ⬅](https://github.com/SwipeCellKit/SwipeCellKit)
* [UIImageColors 🎨](https://github.com/jathu/UIImageColors)
* [SDWebImage 📸](https://github.com/SDWebImage/SDWebImage)
* [SwiftyJSON 😎](https://github.com/SwiftyJSON/SwiftyJSON)


## My attempt at a privacy policy

I, the developer of **Puff**, do not have access to any of the information you enter into **Puff**. All of that information is stored on your iPhone (peep 👀 the source code for proof!). This being said, I am not responsible for your data being compromised should your phone fall into the hands of someone with malicious intents. If you leave your phone unlocked and your cat logs into **Puff** and changes your Netflix account's password, welp, that's on you! (I would also get rid of that cat ASAP!) The passwords you do store are stored in iOS keychain which we can think of as a black box of security stuff that Apple meticulously designed that I can't really explain. But bottom line, this is just a project by a college student so think responsibly and, most importantly, don't sue me! (Seriously, the college budget does not cover a lawsuit's associated legal fees! 😅)
