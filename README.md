#ayOS Wiki

# The Official raywenderlich.com Swift Style Guide.

This style guide is different from others you may see, because the focus is centered on readability for print and the web. We created this style guide to keep the code in our books, tutorials, and starter kits nice and consistent — even though we have many different authors working on the books.

Our overarching goals are conciseness, readability, and simplicity.

Writing Objective-C? Check out our [Objective-C Style Guide](https://github.com/raywenderlich/objective-c-style-guide) too.

## Table of Contents

* [Naming](#naming)
  * [Prose](#prose)
  * [Class Prefixes](#class-prefixes)
* [Spacing](#spacing)
* [Comments](#comments)
* [Classes and Structures](#classes-and-structures)
  * [Use of Self](#use-of-self)
  * [Protocol Conformance](#protocol-conformance)
  * [Computed Properties](#computed-properties)
* [Function Declarations](#function-declarations)
* [Closure Expressions](#closure-expressions)
* [Types](#types)
  * [Constants](#constants)
  * [Optionals](#optionals)
  * [Struct Initializers](#struct-initializers)
  * [Type Inference](#type-inference)
  * [Syntactic Sugar](#syntactic-sugar)
* [Control Flow](#control-flow)
* [Semicolons](#semicolons)
* [Language](#language)
* [Copyright Statement](#copyright-statement)
* [Smiley Face](#smiley-face)
* [Credits](#credits)


## Naming

Use descriptive names with camel case for classes, methods, variables, etc. Class names should be capitalized, while method names and variables should start with a lower case letter.

**Preferred:**

```swift
private let maximumWidgetCount = 100

class WidgetContainer {
  var widgetButton: UIButton
  let widgetHeightPercentage = 0.85
}
```

**Not Preferred:**

```swift
let MAX_WIDGET_COUNT = 100

class app_widgetContainer {
  var wBut: UIButton
  let wHeightPct = 0.85
}
```

For functions and init methods, prefer named parameters for all arguments unless the context is very clear. Include external parameter names if it makes function calls more readable.

```swift
func dateFromString(dateString: String) -> NSDate
func convertPointAt(column column: Int, row: Int) -> CGPoint
func timedAction(afterDelay delay: NSTimeInterval, perform action: SKAction) -> SKAction!

// would be called like this:
dateFromString("2014-03-14")
convertPointAt(column: 42, row: 13)
timedAction(afterDelay: 1.0, perform: someOtherAction)
```

For methods, follow the standard Apple convention of referring to the first parameter in the method name:

```swift
class Counter {
  func combineWith(otherCounter: Counter, options: Dictionary?) { ... }
  func incrementBy(amount: Int) { ... }
}
```

### Enumerations

Use UpperCamelCase for enumeration values:

```swift
enum Shape {
  case Rectangle
  case Square
  case Triangle
  case Circle
}
```

### Prose

When referring to functions in prose (tutorials, books, comments) include the required parameter names from the caller's perspective or `_` for unnamed parameters.

> Call `convertPointAt(column:row:)` from your own `init` implementation.
>
> If you call `dateFromString(_:)` make sure that you provide a string with the format "yyyy-MM-dd".
>
> If you call `timedAction(afterDelay:perform:)` from `viewDidLoad()` remember to provide an adjusted delay value and an action to perform.
>
> You shouldn't call the data source method `tableView(_:cellForRowAtIndexPath:)` directly.

When in doubt, look at how Xcode lists the method in the jump bar – our style here matches that.

![](https://raw.githubusercontent.com/raywenderlich/swift-style-guide/master/screens/xcode-jump-bar.png)

### Class Prefixes

Swift types are automatically namespaced by the module that contains them and you should not add a class prefix. If two names from different modules collide you can disambiguate by prefixing the type name with the module name.

```swift
import SomeModule

let myClass = MyModule.UsefulClass()
```


## Spacing

* Indent using 2 spaces rather than tabs to conserve space and help prevent line wrapping. Be sure to set this preference in Xcode as shown below:

  ![](https://github.com/raywenderlich/swift-style-guide/raw/master/screens/indentation.png)

* Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.
* Tip: You can re-indent by selecting some code (or ⌘A to select all) and then Control-I (or Editor\Structure\Re-Indent in the menu). Some of the Xcode template code will have 4-space tabs hard coded, so this is a good way to fix that.

**Preferred:**
```swift
if user.isHappy {
  // Do something
} else {
  // Do something else
}
```

**Not Preferred:**
```swift
if user.isHappy
{
    // Do something
}
else {
    // Do something else
}
```

* There should be exactly one blank line between methods to aid in visual clarity and organization. Whitespace within methods should separate functionality, but having too many sections in a method often means you should refactor into several methods.

## Comments

When they are needed, use comments to explain **why** a particular piece of code does something. Comments must be kept up-to-date or deleted.

Avoid block comments inline with code, as the code should be as self-documenting as possible. *Exception: This does not apply to those comments used to generate documentation.*


## Classes and Structures

### Which one to use?

Remember, structs have [value semantics](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_144). Use structs for things that do not have an identity. An array that contains [a, b, c] is really the same as another array that contains [a, b, c] and they are completely interchangeable. It doesn't matter whether you use the first array or the second, because they represent the exact same thing. That's why arrays are structs.

Classes have [reference semantics](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_145). Use classes for things that do have an identity or a specific life cycle. You would model a person as a class because two person objects are two different things. Just because two people have the same name and birthdate, doesn't mean they are the same person. But the person's birthdate would be a struct because a date of 3 March 1950 is the same as any other date object for 3 March 1950. The date itself doesn't have an identity.

Sometimes, things should be structs but need to conform to `AnyObject` or are historically modeled as classes already (`NSDate`, `NSSet`). Try to follow these guidelines as closely as possible.

### Example definition

Here's an example of a well-styled class definition:

```swift
class Circle: Shape {
  var x: Int, y: Int
  var radius: Double
  var diameter: Double {
    get {
      return radius * 2
    }
    set {
      radius = newValue / 2
    }
  }

  init(x: Int, y: Int, radius: Double) {
    self.x = x
    self.y = y
    self.radius = radius
  }

  convenience init(x: Int, y: Int, diameter: Double) {
    self.init(x: x, y: y, radius: diameter / 2)
  }

  func describe() -> String {
    return "I am a circle at \(centerString()) with an area of \(computeArea())"
  }

  override func computeArea() -> Double {
    return M_PI * radius * radius
  }

  private func centerString() -> String {
    return "(\(x),\(y))"
  }
}
```

The example above demonstrates the following style guidelines:

 + Specify types for properties, variables, constants, argument declarations and other statements with a space after the colon but not before, e.g. `x: Int`, and `Circle: Shape`.
 + Define multiple variables and structures on a single line if they share a common purpose / context.
 + Indent getter and setter definitions and property observers.
 + Don't add modifiers such as `internal` when they're already the default. Similarly, don't repeat the access modifier when overriding a method.


### Use of Self (Don't follow this for now, always use self.)

For conciseness, avoid using `self` since Swift does not require it to access an object's properties or invoke its methods.

Use `self` when required to differentiate between property names and arguments in initializers, and when referencing properties in closure expressions (as required by the compiler):

```swift
class BoardLocation {
  let row: Int, column: Int

  init(row: Int, column: Int) {
    self.row = row
    self.column = column
    
    let closure = {
      println(self.row)
    }
  }
}
```

### Protocol Conformance

When adding protocol conformance to a class, prefer adding a separate class extension for the protocol methods. This keeps the related methods grouped together with the protocol and can simplify instructions to add a protocol to a class with its associated methods.

Also, don't forget the `// MARK: -` comment to keep things well-organized!

**Preferred:**
```swift
class MyViewcontroller: UIViewController {
  // class stuff here
}

// MARK: - UITableViewDataSource
extension MyViewcontroller: UITableViewDataSource {
  // table view data source methods
}

// MARK: - UIScrollViewDelegate
extension MyViewcontroller: UIScrollViewDelegate {
  // scroll view delegate methods
}
```

**Not Preferred:**
```swift
class MyViewcontroller: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // all methods
}
```

### Computed Properties

For conciseness, if a computed property is read-only, omit the get clause. The get clause is required only when a set clause is provided.

**Preferred:**
```swift
var diameter: Double {
  return radius * 2
}
```

**Not Preferred:**
```swift
var diameter: Double {
  get {
    return radius * 2
  }
}
```

## Function Declarations

Keep short function declarations on one line including the opening brace:

```swift
func reticulateSplines(spline: [Double]) -> Bool {
  // reticulate code goes here
}
```

For functions with long signatures, add line breaks at appropriate points and add an extra indent on subsequent lines:

```swift
func reticulateSplines(spline: [Double], adjustmentFactor: Double,
    translateConstant: Int, comment: String) -> Bool {
  // reticulate code goes here
}
```


## Closure Expressions

Use trailing closure syntax only if there's a single closure expression parameter at the end of the argument list. Give the closure parameters descriptive names.

**Preferred:**
```swift
UIView.animateWithDuration(1.0) {
  self.myView.alpha = 0
}

UIView.animateWithDuration(1.0,
  animations: {
    self.myView.alpha = 0
  },
  completion: { finished in
    self.myView.removeFromSuperview()
  }
)
```

**Not Preferred:**
```swift
UIView.animateWithDuration(1.0, animations: {
  self.myView.alpha = 0
})

UIView.animateWithDuration(1.0,
  animations: {
    self.myView.alpha = 0
  }) { f in
    self.myView.removeFromSuperview()
}
```

For single-expression closures where the context is clear, use implicit returns:

```swift
attendeeList.sort { a, b in
  a > b
}
```


## Types

Always use Swift's native types when available. Swift offers bridging to Objective-C so you can still use the full set of methods as needed.

**Preferred:**
```swift
let width = 120.0                                    // Double
let widthString = (width as NSNumber).stringValue    // String
```

**Not Preferred:**
```swift
let width: NSNumber = 120.0                          // NSNumber
let widthString: NSString = width.stringValue        // NSString
```

In Sprite Kit code, use `CGFloat` if it makes the code more succinct by avoiding too many conversions.

### Constants

Constants are defined using the `let` keyword, and variables with the `var` keyword. Always use `let` instead of `var` if the value of the variable will not change.

**Tip:** A good technique is to define everything using `let` and only change it to `var` if the compiler complains!


### Optionals

Declare variables and function return types as optional with `?` where a nil value is acceptable.

Use implicitly unwrapped types declared with `!` only for instance variables that you know will be initialized later before use, such as subviews that will be set up in `viewDidLoad`.

When accessing an optional value, use optional chaining if the value is only accessed once or if there are many optionals in the chain:

```swift
self.textContainer?.textLabel?.setNeedsDisplay()
```

Use optional binding when it's more convenient to unwrap once and perform multiple operations:

```swift
if let textContainer = self.textContainer {
  // do many things with textContainer
}
```

When naming optional variables and properties, avoid naming them like `optionalString` or `maybeView` since their optional-ness is already in the type declaration.

For optional binding, shadow the original name when appropriate rather than using names like `unwrappedView` or `actualLabel`.

**Preferred:**
```swift
var subview: UIView?
var volume: Double?

// later on...
if let subview = subview, volume = volume {
  // do something with unwrapped subview and volume
}
```

**Not Preferred:**
```swift
var optionalSubview: UIView?
var volume: Double?

if let unwrappedSubview = optionalSubview {
  if let realVolume = volume {
    // do something with unwrappedSubview and realVolume
  }
}
```

### Struct Initializers

Use the native Swift struct initializers rather than the legacy CGGeometry constructors.

**Preferred:**
```swift
let bounds = CGRect(x: 40, y: 20, width: 120, height: 80)
let centerPoint = CGPoint(x: 96, y: 42)
```

**Not Preferred:**
```swift
let bounds = CGRectMake(40, 20, 120, 80)
let centerPoint = CGPointMake(96, 42)
```

Prefer the struct-scope constants `CGRect.infinite`, `CGRect.null`, etc. over global constants `CGRectInfinite`, `CGRectNull`, etc. For existing variables, you can use the shorter `.zero`.

### Type Inference

Prefer compact code and let the compiler infer the type for a constant or variable, unless you need a specific type other than the default such as `CGFloat` or `Int16`.

**Preferred:**
```swift
let message = "Click the button"
let currentBounds = computeViewBounds()
var names = [String]()
let maximumWidth: CGFloat = 106.5
```

**Not Preferred:**
```swift
let message: String = "Click the button"
let currentBounds: CGRect = computeViewBounds()
var names: [String] = []
```

**NOTE**: Following this guideline means picking descriptive names is even more important than before.


### Syntactic Sugar

Prefer the shortcut versions of type declarations over the full generics syntax.

**Preferred:**
```swift
var deviceModels: [String]
var employees: [Int: String]
var faxNumber: Int?
```

**Not Preferred:**
```swift
var deviceModels: Array<String>
var employees: Dictionary<Int, String>
var faxNumber: Optional<Int>
```


## Control Flow

Prefer the `for-in` style of `for` loop over the `for-condition-increment` style.

**Preferred:**
```swift
for _ in 0..<3 {
  println("Hello three times")
}

for (index, person) in attendeeList.enumerate() {
  println("\(person) is at position #\(index)")
}
```

**Not Preferred:**
```swift
for var i = 0; i < 3; i++ {
  println("Hello three times")
}

for var i = 0; i < attendeeList.count; i++ {
  let person = attendeeList[i]
  println("\(person) is at position #\(i)")
}
```


## Semicolons

Swift does not require a semicolon after each statement in your code. They are only required if you wish to combine multiple statements on a single line.

Do not write multiple statements on a single line separated with semicolons.

The only exception to this rule is the `for-conditional-increment` construct, which requires semicolons. However, alternative `for-in` constructs should be used where possible.

**Preferred:**
```swift
let swift = "not a scripting language"
```

**Not Preferred:**
```swift
let swift = "not a scripting language";
```

**NOTE**: Swift is very different to JavaScript, where omitting semicolons is [generally considered unsafe](http://stackoverflow.com/questions/444080/do-you-recommend-using-semicolons-after-every-statement-in-javascript)

## Language

Use US English spelling to match Apple's API.

**Preferred:**
```swift
let color = "red"
```

**Not Preferred:**
```swift
let colour = "red"
```

## Copyright Statement

The following copyright statement should be included at the top of every source
file:

    /*
     * Copyright (c) 2015 Razeware LLC
     * 
     * Permission is hereby granted, free of charge, to any person obtaining a copy
     * of this software and associated documentation files (the "Software"), to deal
     * in the Software without restriction, including without limitation the rights
     * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     * copies of the Software, and to permit persons to whom the Software is
     * furnished to do so, subject to the following conditions:
     * 
     * The above copyright notice and this permission notice shall be included in
     * all copies or substantial portions of the Software.
     * 
     * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
     * THE SOFTWARE.
     */

## Smiley Face

Smiley faces are a very prominent style feature of the raywenderlich.com site! It is very important to have the correct smile signifying the immense amount of happiness and excitement for the coding topic. The closing square bracket `]` is used because it represents the largest smile able to be captured using ASCII art. A closing parenthesis `)` creates a half-hearted smile, and thus is not preferred.

**Preferred:**
```
:]
```

**Not Preferred:**
```
:)
```  


## Credits

This style guide is a collaborative effort from the most stylish raywenderlich.com team members: 

* [Jawwad Ahmad](https://github.com/jawwad)
* [Soheil Moayedi Azarpour](https://github.com/moayes)
* [Scott Berrevoets](https://github.com/Scott90)
* [Eric Cerney](https://github.com/ecerney)
* [Sam Davies](https://github.com/sammyd)
* [Evan Dekhayser](https://github.com/edekhayser)
* [Jean-Pierre Distler](https://github.com/pdistler)
* [Colin Eberhardt](https://github.com/ColinEberhardt)
* [Greg Heo](https://github.com/gregheo)
* [Matthijs Hollemans](https://github.com/hollance)
* [Erik Kerber](https://github.com/eskerber)
* [Christopher LaPollo](https://github.com/elephantronic)
* [Ben Morrow](https://github.com/benmorrow)
* [Andy Pereira](https://github.com/macandyp)
* [Ryan Nystrom](https://github.com/rnystrom)
* [Andy Obusek](https://github.com/obuseme)
* [Cesare Rocchi](https://github.com/funkyboy)
* [Ellen Shapiro](https://github.com/designatednerd)
* [Marin Todorov](https://github.com/icanzilb)
* [Chris Wagner](https://github.com/cwagdev)
* [Ray Wenderlich](https://github.com/rwenderlich)
* [Jack Wu](https://github.com/jackwu95)

Hat tip to [Nicholas Waynik](https://github.com/ndubbs) and the [Objective-C Style Guide](https://github.com/raywenderlich/objective-c-style-guide) team!

We also drew inspiration from Apple’s reference material on Swift:

* [The Swift Programming Language](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/index.html)
* [Using Swift with Cocoa and Objective-C](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/index.html)
* [Swift Standard Library Reference](https://developer.apple.com/library/prerelease/ios/documentation/General/Reference/SwiftStandardLibraryReference/index.html)

```

# Git Basics  
## Table of Contents
[1. Branches](#branches)  
[1.1. Master Branch](#master-branch)  
[1.2. Development Branch](#development-branch)  
[1.3. Feature Branch](#feature-branch)  
[2. Pull Requests](#pull-requests)  
[3. Merging](#merging)  
[4. Code Review](#code-review)  
[5. Tags and Versioning](#tags-and-versioning)  
[6. Issues](#issues)

## 1. Branches

### 1.1. Master Branch   
This is also called the deployment or production branch. Branching out from this branch, except the development branch, is prohibited.

### 1.2. Development Branch
This is the parent branch for all the feature branches and the one and only child branch of the master branch. Do not make any changes on this branch.

```git
$ git pull origin development
# Do a pull command to get the latest updates from the remote copy.
```

### 1.3. Feature Branch
Developer works on this branch for the implementation of a certain feature. Naming should be descriptive as much as possible.

**How to create a feature branch:**

```git
$ git pull origin development
# Gets the latest updates from the remote copy of the development branch. 

$ git checkout -b feature-branch-name development
# Creates locally a new child branch with a name 'feature-branch-name' 
# from the development branch.


$ git branch
  development
* feature-branch-name
  master
# Shows the current checkout branch indicated by the asterisk.
  
$ git push -u origin feature-branch-name
# Pushes your newly created local branch to the repository.
# The -u argument is necessary for argument-less git-pull.
# For more details about -u, visit http://bit.ly/1GpOFxo.
```  

**Take note in pushing changes:**  

```git
$ git checkout feature-branch-name
# Navigates to a particular branch

$ git push
# This will push changes from the current branch.
```
```git
$ git push origin
# This will push changes from all local branches 
# to matching branches in the remote.
```
```git
$ git branch
  development
  feature-branch-name
* feature-branch-name-2
  master
# This will make sure that if the developer wants
# to push the changes made in 'feature-branch-name-2'.

$ git push 
```
```git
$ git push origin feature-branch-name
# This is the preferred way of pushing the changes that
# is by specifying the branch.
```

**Deleting feature branches:**

```git
$ git branch -d feature-branch-name
# Deletes a local branch

$ git push origin --delete feature-branch-name
# Deleting a remote branch
```

## 2. Pull Requests
Pull requests are used to manage changes made from contributors or developers [[1]](http://yangsu.github.io/pull-request-tutorial/). These are living conversations that streamline the process of discussing, reviewing, and managing changes to code [[2]](https://github.com/features).  
  
Once a pull request is sent, project maintainers can review the set of changes and discuss potential modification [[3]](https://help.github.com/articles/using-pull-requests/#article-platform-nav). In other words, when a developer has filed a pull request it means that he/she is requesting the project maintainer to pull the changes from his/her branch to another branch (also from repo to another repo) [[4]](https://www.atlassian.com/git/tutorials/making-a-pull-request).  
  
Before filing a pull request, you must compare the source branch/repo to the destination branch/repo and if there are changes to the destination branch, **merge** with and **test** the changes from the destination branch [[5]](https://confluence.atlassian.com/display/BITBUCKET/Work+with+pull+requests). After a successful merge, conflict resolutions, and fixes on the affected changes (this might arise because of the merge), the developer can now file a pull request.

**General Process:** [[6]](https://www.atlassian.com/git/tutorials/making-a-pull-request/how-it-works)    
>
1. A developer creates the feature in a dedicated branch in their local repo.  
2. The developer pushes the branch to a repository.  
3. The developer files a pull request.  
4. The team reviews the code, discusses it, and alters it.  
5. The project maintainer merges the feature into the official repository and closes the pull request.

## 3. Merging
After a pull request from a feature branch is being code reviewed and there are no problems, the project maintainer merge the feature branch into the development branch.

```git
$ git checkout development
# Switches to the development branch.

$ git merge --no-ff feature-branch-name
# Merges the current branch to the specified branch
# which is the 'feature-branch-name'.
# The '--no-ff' argument generates a merge commit.
# This is useful for documenting all merges done.
```

After a thorough testing on the development branch and there are no problems, the project maintainer can now merge the development branch into the master branch.

```git
$ git checkout master
# Switches to master branch.

$ git merge --no-ff development
# Merges the master and development branches.
```

## 4. Code Review
Code review helps disseminate knowledge across teams, catches bugs (or more likely poor architectural decisions) before they bite you, and provide opportunities to educate junior engineers [[7]](http://justinlilly.com/misc/state_of_githubs_code_review.html).

## 5. Tags and Versioning
Tagging in Git is a great way to denote specific release versions of your code [[8]](http://gitready.com/beginner/2009/02/03/tagging.html). Naming of tags should be in this format:

```git
rel-v1.0.0
rel-v1.0.1
rel-v1.1.0
# Production

dev-v1.0.0.1
dev-v1.0.0.2
dev-v1.0.0.3
dev-v1.0.1.1
# Development
```
**Creating and pushing tags:**

```git
$ git checkout master
# Switches to the master branch

$ git tag -a rel-v1.0.0 -m "Created the first version."
# Creates a tag


$ git tag
rel-v1.0.0
# Shows all tags

$ git push --tags
# Pushing tags to the remote repo

$ git push origin rel-v1.0.0
# Pushing a specific tag
```

## 6. Issues
Issues are a great way to keep track of tasks, enhancements, and bugs for your projects and they’re kind of like email—except they can be shared and discussed with the rest of your team [[9]](https://guides.github.com/features/issues/index.html).

* [Bitbucket](https://confluence.atlassian.com/display/BITBUCKET/Use+the+issue+tracker)  
* [GitHub](https://guides.github.com/features/issues/)  

# Git Convention

## 1. Commits
### 1.1 Creating commit messages
* Commit message begins with the defined prefix

```git
PREFIX:
Added | Implemented | Refactored | Optimized | Enhanced | Applied | Resolved | Removed

EXAMPLE:
> Added condition for comparing nil values.
> Implemented forgot password feature.
> Refactored login view controller according to the coding convention.
> Optimized loading of images from server.
> Enhanced scrolling experience.
> Applied parallax in user profile.
> Resolved on displaying no results upon searching.
> Removed method because it is marked as deprecated.
```
* Commit messages with related issue

```git
FORMAT:
<commit-message><space>(issue<space>#<issue-number>)

EXAMPLE:
Added condition for comparing nil values. (issue #43)
```

### 1.2. Editing commit messages
To edit the message of the last commit

```git
$ git commit --amend -m "Applied edit in commit message."
```

To edit the message of a specific commit

```git
$ git rebase -i --root

# Rebasing starting from desired commit to edit
# commit_id is the commit before the desired commit to edit
$ git rebase -i [commit_id]

# Change 'pick' to 'edit'.
# Change author of the commit
$ git commit --amend -m "Applied commit message edit."

# If you are only amending the message of a specified commit,
# just change 'pick' to 'reword'. Then, modified the commit
# message. Finally, saves it.

# Continue rebasing
$ git rebase --continue
```

### 1.3. Editing the author
To edit the author of the last commit  

```git
$ git commit --amend --author "New Author Name <new-email@address.com>"
```

To edit the author of a specific commit

```git
$ git rebase -i --root

# Rebasing starting from desired commit to edit
# commit_id is the commit before the desired commit to edit
$ git rebase -i [commit_id]

# Change 'pick' to 'edit'.

# Change author of the commit
$ git commit --amend --author "New Author Name <new-email@address.com>"

# Continue rebasing
$ git rebase --continue
```

### 1.4. Combining commits
To combine commits

```git
$ git rebase -i --root

pick a370067 A
pick adcc327 B
pick 88863d3 C
pick 4b8af9b D
pick 6da0935 E

# Combine D and B.
# Edit and rearrange the commits accordingly.
# Then replace 'pick' with 'squash' in 'pick 4b8af9b D'
pick a370067 A
pick adcc327 B
squash 4b8af9b D
pick 88863d3 C
pick 6da0935 E

# Save the file and quit.

# Edit the necessary commit message for the combined B and D.
# Save the file and quit.

# In case there are conflict on files, this error appears:
# "error: could not apply caed537... Added water animals.".
# Just use the part having 'Added water animals'
#
# Example:
# >>>>>> HEAD
# The quick brown fox
# ======
# The quick brown fox jumps over the lazy dog.
# >>>>>> Added water animals
#
# Ignore the HEAD, retain the 'Added water animals'.

# Then do the usual
$ git add [file]

# Then, continue rebasing again
$ git rebase --continue
```

### 1.5. Updating commit contents
To update the content of a commit

```git
$ git rebase -i --root

# Rebasing starting from desired commit to edit
# commit_id is the commit before the desired commit to edit
$ git rebase -i [commit_id]

# Change 'pick' to 'edit'.

# Edit the necessary files that involve for that commit.

# Then, do the usual.
$ git add [file]

# Amend the commit.
$ git commit --amend

# Then, save the commit.

# Continue rebasing
$ git rebase --continue

# There is chance that this rebase causes conflict to another
# commit. You have to fix it before to continue rebasing.

# Edit and fix the conflict on the related files.

# Then, do the usual
$ git add [file]

# Then, continue rebasing again
$ git rebase --continue
```

### 1.6. Reverting HEAD from a rebase
To revert to a specific head due to a bad rebase

```git
$ git reflog

# Suppose the old commit was HEAD@{5} in the ref log
git reset --hard HEAD@{5}
```

### 1.7. Showing commit messages

```git
$ git log
# Prints the details of each comit.

$ git log --oneline
# Prints commit messages in one line.

$ git log --oneline development..other-branch
# Shows all the commits that are not in the
# development branch.
```

## 2. Issues
* Setting the title

```git
PREFIX: 
Add | Implement | Refactor | Optimize | Enhance | Apply | Resolve | Remove

EXAMPLE:
> Add avatar and cover photo in user profile
> Implement response caching in friend list
> Refactor for coding convention and documentation
> Optimize parsing models
> Enhance product name labels
> Resolve regarding with the redundancy of views
> Apply push navigation instead of modal
> Remove the files of the classes that are marked as deprecated
``` 

* The reporter must set the description of the issue. Do not submit the issue if there is no description.

## 3. Pull Requests
* Compare and review the differences of the source and destination branch.
* Try to spot issues that the reviewer might find and clean up those.
* Be descriptive with the title. Make it comprehensive. It can be rephrased from the issue title. As much as possible, the title should be related to the issue.
* Explain some details in the description on what you have done.
* Approve the pull requests once all the commits are approved.

## 4. Branch Naming
```git
FORMAT:
<change-types>/<feature>/<detail>

CHANGE TYPES:
add | implement | refactor | optimize | enhance | apply | resolve | remove

FEATURE: 
lowercase words separated by dashes (-)

DETAIL:
lowercase words separated by dashes (-)

EXAMPLE:
> resolve/login/display-errors-from-response
> refactor/login/coding-convention-in-login-controller
> implement/forgot-password
> enhance/home/product-table-view-cells 
```
## 5. ToDos
**Developer**

* Create issue on the assigned tasks and issues in mantis.
* Create branch from development locally.
* Push the branch to remote.
* Work with that branch.
* Commit all your changes daily.
* Once done, compare the branch from development and review the changes.
* Clean up your commits by rebasing (i.e. editing commit messages, combining necessary commits, etc).
* Create a pull request.
* Do not add a separate commit if there are comments given by the reviewer on it. (such as coding convention, optimization, etc). Instead, perform a rebase and amend the commit.
* Once the pull request is approved and merged to the development, go to the issues related to that branch and mark it as resolved.  

**Monitoring Person**

* Assign tasks by creating an issue.
* Check the issues reported by the developers. Make sure that the title and the description are comprehensive.
* If there are pull requests, proof-read it's title and description.
* Edit the pull requests as necessary.
* Review each commit and put some comments.
* Request a rebase as necessary.
* If there's nothing wrong in the commit, approve it.
* Once all commits are approved, approve and merge the pull request.  

# Workflow for Resolving Issue
## Supplementary Tools
- Trello  
- Mantis 
- Bitbucket

## Considerations
- Build app for testing.
- Wait for the test result to be uploaded in trello.
- While waiting, the monitoring person will frequently check mantis for the reported issues and then assign a person to deal with it.
- Fixing the issue, the developer should create an issue in bitbucket.
- The developer should create a new branch from the development branch to fix the issue.
- The developer should create a pull request.
- Once the pull request is merged, the monitoring person marked the bitbucket issue as 'resolved'.
- All bitbucket issues must be marked as 'resolved' before changing the status of all the mantis issues to 'resolve'. Then, the assigned developer for the issue should change the status to 'resolved' in mantis.
- If the status of the issue in mantis is changed to 'close', the monitoring person should change the bitbucket issue to 'closed' respectively.
- If the tester approaches because he/she can not perform the other test cases due to application crash issues, the assigned developer must prioritize to fix that issue (development hot fixes).
- If all the mantis issues are changed to 'resolve', build the app for testing again.
- Once the pull request of the developer is merged into the development branch, he/she can now click the resolve button of the bitbucket issue.

## Collaborating Mantis and Bitbucket

### Creating Bitbucket Issues

- Setting the title of the issue

```
FORMAT:
Resolve <Re-phrased-title-that-is-set-in-Mantis>

EXAMPLE:
Mantis: should follow a priority of validation
Bitbucket: Resolve on the priority validation in registration
```

- Setting the description of the issue

```
FORMAT:
<Mantis-Issue-Description>

Mantis [<Mantis-Issue-ID>](<link-that-redirects-to-mantis>)

EXAMPLE:
Should follow a priority of validation
1. username
2. password
3. confirm password
4. mobile
5. email

Mantis [3584](http://example.org:83/view.php?id=3643).
```

- If the title and description is the same, just set the issue's description to

```
Mantis [<Mantis-Issue-ID>](<link-that-redirects-to-mantis>)
```

- Title and description must start with an uppercase letter
- Default title of the issue is the `<Mantis-Issue-Title>`
- The montioring person has an option to rename and edit the title and give more details in the description appropriately
- If the issue reporter is confused on what title he/she should set, just choose the default title

## Design Pattern (iOS App)

### Components

* Server
* APIManager
* View
* ViewController
* Model
* User

```
                                 +----------------+
                                 |                |
                                 |     Server     |
                                 |                |
                                 +----------------+
                                   @            |
                                   |            | respond 
                           request |            |
                                   |            @
                                 +----------------+ 
                                 |                |
                                 |   APIManager   |
                                 |                |
                                 +----------------+
                                   @            | 
                                   |            | hand over response
                     fire request  |            |
                                   |            |
                  notify action    |            @
        +------+    performed    +----------------+  update/create  +-------+
        |      |----------------@|                |----------------@|       |
        | View |                 | ViewController |                 | Model |
        |      |@----------------|                |@----------------|       |
        +------+     update      +----------------+   notify data   +-------+
         @    |                                     updated/created
         |    | display
interact |    |
         |    @
           0
          /|\ user
          / \         
``` 

# The Ten Commandments of Egoless Programming

1. **Understand and accept that you will make mistakes.** The point is to find them early, before they make it into production. Fortunately, except for the few of us developing rocket guidance software at JPL, mistakes are rarely fatal in our industry. We can, and should, learn, laugh, and move on.

2. **You are not your code.** Remember that the entire point of a review is to find problems, and problems will be found. Don’t take it personally when one is uncovered.

3. **No matter how much “karate” you know, someone else will always know more.** Such an individual can teach you some new moves if you ask. Seek and accept input from others, especially when you think it’s not needed.

4. **Don’t rewrite code without consultation.** There’s a fine line between “fixing code” and “rewriting code.” Know the difference, and pursue stylistic changes within the framework of a code review, not as a lone enforcer.

5. **Treat people who know less than you with respect, deference, and patience.** Non-technical people who deal with developers on a regular basis almost universally hold the opinion that we are prima donnas at best and crybabies at worst. Don’t reinforce this stereotype with anger and impatience.

6. **The only constant in the world is change.** Be open to it and accept it with a smile. Look at each change to your requirements, platform, or tool as a new challenge, rather than some serious inconvenience to be fought.

7. **The only true authority stems from knowledge, not from position.** Knowledge engenders authority, and authority engenders respect – so if you want respect in an egoless environment, cultivate knowledge.

8. **Fight for what you believe, but gracefully accept defeat.** Understand that sometimes your ideas will be overruled. Even if you are right, don’t take revenge or say “I told you so.” Never make your dearly departed idea a martyr or rallying cry.

9. **Don’t be “the coder in the corner.”** Don’t be the person in the dark office emerging only for soda. The coder in the corner is out of sight, out of touch, and out of control. This person has no voice in an open, collaborative environment. Get involved in conversations, and be a participant in your office community.

10. **Critique code instead of people – be kind to the coder, not to the code.** As much as possible, make all of your comments positive and oriented to improving the code. Relate comments to local standards, program specs, increased performance, etc.
<b/>
[Reference](http://blog.stephenwyattbush.com/2012/04/07/dad-and-the-ten-commandments-of-egoless-programming)
<b/>

####[Credits to: Mounir Ybanez] (https://www.facebook.com/mounirandre?fref=ts) 

in progress -> In Review -> Rejected or Ready for merge.
