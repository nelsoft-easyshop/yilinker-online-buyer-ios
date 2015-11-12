#ayOS Wiki

#Coding Convention (Objective-C)
This coding convention is inspired by the [official raywenderlich.com Objective-C style guide](https://github.com/raywenderlich/objective-c-style-guide/blob/master/README.md#literals).
##Table of Contents
[1. Code Organization](#code-organization)  
[1.1. Using **`#pragma mark`**](#using-pragma-mark)  
[1.2. Project Structure](#project-structure)  
[2. Spacing](#spacing)  
[2.1. Indentation](#indentation)  
[2.2. Braces](#braces)  
[2.3. Scope's First Line](#first-line)  
[2.4. If-Else and Loops](#if-else-and-loop)  
[2.5. Case Statements](#case-statements)  
[3. Naming](#naming)  
[3.1. Variables](#variables)  
[3.2. Methods](#methods)  
[3.3. Classes](#classes)  
[4. Declaration](#declration)  
[4.1. Properties](#properties)  
[4.2. Enumerated Types](#enumerated-types)  
[4.3. Custom Constructor](#custom-constructor)  
[4.4. Literals](#literals)  
[4.5. Constants](#constants)  
[4.6. Singleton](#singleton)  
[4.7. Private Methods and Variables](#private-methods-and-variables)  
[5. Custom Views](#custom-views)

##1. Code Organization

###1.1 Using `#pragma mark`

Use this for method categorization. First letter of the word should be in upper case. Every custom delegate and data source should be organized by using `#pragma mark`. Every method involving in the loading of view should be under `#pragma mark - View Life Cycle`.

**Preferred**

```objective-c
@implementation MYViewController

#pragma mark -
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad]
    ...
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]
    ...
}

#pragma mark -
#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark -
#pragma mark - Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    ...
    return cell;
}
@end

```

**Not Preferred**

```objective-c
#pragma mark -
#pragma mark - table view delegate

...

#pragma mark -
#pragma mark - table View DaTa SouRce
```

###1.2 Project Structure
This would be the typical structure of an Xcode project. All items in `Externals`, `Categories`, `Helpers`, and `Experiment` should have a specific folder group.

```
|__ProjectName
|    |__Source
|    |    |__App Delegate
|    |    |__Categories
|    |    |__Controllers
|    |    |__Experiment
|    |    |__Externals
|    |    |__Helpers
|    |    |__Models
|    |    |__Resources
|    |    |    |__Storyboards
|    |    |    |__Database
|    |    |    |__HTMLs
|    |    |    |__Images
|    |    |    |__JSONFiles
|    |    |    |__Xibs
|    |    |    |__Image.xcassets
|    |    |__Views
|    |__Supporting Files
|__ProjectNameTests
|__Frameworks
|__Pods
|__Products
```

##2. Spacing

###2.1 Indentation
Just indent 4 spaces.

**Preferred**

```objective-c
- (void)foo {
----if (!bar) {
--------for (int i = 0; i < 5; i++) {
------------NSString *bar = [NSString stringWithFormat:@"%d", i];
------------...
--------}    
----} else {
--------...
----}
}
```

###2.2 Braces
Put the open brace 1 space inline with the method and other control statements. 

**Preferred**

```objective-c
- (void)foo {
    if (!bar) {
        while (woo) {
            ...
        }
    } else {
        ...
    }
}
```
**Not Preferred**

```objective-c
- (void)foo{
    if (!bar) 
    {
        while (woo){
            ...
        }
    } else {
        ...
    }
}
```

###2.3 Scope's First Line
Avoid putting new line space above the first line of a scope.

**Preferred**

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (foo) {
        int bar = 0;
        ...
    }
    ...
}
```

**Not Preferred**

```objective-c
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (foo) {
        
        int bar = 0;
    }
    
}
```
###2.4 If-Else and Loops

**Preferred**

```objective-c
for (int i = 0; i < 10; i++) {
    if (!foo) {
        ... 
    } else if (bar) {
        ... 
    } else {
        ... 
    }       
}
```

**Not Preferred**

```objective-c
for(int i =0; i< 10;i++) {
    if(!foo) {
        ... 
    }else if (bar) {
        ... 
    }else{
        ... 
    }       
}
```

###2.5 Case Statements

**Preferred**

```objective-c
switch (foo) {
    case 1: {
        // Multi-line using braces
        ...
    }
        break;
    case 2:
        // Single-line
        ...
        break;
    default:
        ...
        break;     
}
```
**Not Preferred**

```objective-c
switch(foo){
    case 1: 
    {
        // Multi-line using braces
        ...
    }
    break;
    case 2:
        // Single-line
        ...
        break;
    default:
        ...
        break;     
}
```


##3. Naming

###3.1 Variables
Naming of variables should be as descriptive as possible. Single letter variable should be avoided except in `for ()` loops. Variables must be a noun (except for `BOOL`; an adjective would be appropriate). The first letter should be in lower case. Avoid abbreviation. Camel-case style must be followed. The asterisk indicating a pointer should go along with the variable name.

In case of naming a variable for any views such as UIView, UILabel, UIButton, etc, the format would be <variable name><name of the view>

**Preferred**

```objective-c
NSString *firstName = @"Juan";
NSInteger numberOfRows = 10;
NSDictionary *response = @{};
BOOL editable = NO;
UILabel *usernameLabel = [UILabel new];
UIButton *confirmButton = [UIButton new];
```

**Not Preferred**

```objective-c
NSString* FirstName = @"Juan";
NSInteger numRows = 10;
NSDictionary *query_rsesponse = @{};
UILabel *lblUsername = [UILabel new];
UIButton *confirmBtn = [UIButton new];
```

###3.2 Methods
There should be a space after the method type sign `(-/+)`. There should be no space between the return type and the first letter, which should be in lower case, of the method. Methods must be a verb.  A space should be observed between method segments. There should be a keyword before the argument. Avoid using `and` as part of the keyword because it is reserved.
Put the asterisk one space away from the parameter type.

**Preferred**

```objective-c
- (void)setText:(NSString *)text label:(UILabel *)label;
- (CGFloat)convertFromCelsius:(CGFloat)celsius toFahrenheit:(CGFloat)fahrenheit;
- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column;
```

**Not Preferred**

```objective-c
-(void)setText:(NSString *)text label:(UILabel *)label;
- (CGFloat) celsius:(CGFloat)celsius toFahrenheit:(CGFloat)fahrenheit;
- (instancetype)initWithRow:(NSInteger)row andColumn:(NSInteger)column;
```

###3.3 Classes
Classes must be a noun and the first letter must be in upper case. Camel-case style should be followed.

**Preferred**

```objective-c
@interface MYPerson : NSObject
...
@end
```

**Not Preferred**

```objective-c
@interface mYPerson_Upper : NSObject
...
@end
```


##4. Declaration

###4.1 Properties
The attributes of a property should be in this order: _type of storage_, _atomicity_, _custom setter method_, _custom getter method_. There is a space after the `@property` keyword and the declaration of the its attributes. Each attribute must be separated by a comma and a space. If the name of a `BOOL` property is an adjective, the property can omit the word 'is' prefix but must specify the get accessor method.

**Preferred**

```objective-c
@property (strong, nonatomic) NSString *name;
@property (readwrite, nonatomic) NSInteger age;
@property (assign, getter=isValid) BOOL valid;
```

**Not Preferred**

```objective-c
@property(nonatomic, strong) NSString *name;
@property (readwrite,strong)NSInteger age;
```

###4.2 Enumerated Types

**Preferred**

```objective-c
typedef NS_ENUM(NSInteger, MYFinger) {
    MYFingerThumb,
    MYFingerIndex,
    MYFingerMiddle,
    MYFingerRing,
    MyFingerPinky
};
```

**Not Preferred**

```objective-c
typedef enum {
    MYFingerThumb,
    MYFingerIndex,
    MYFingerMiddle,
    MYFingerRing,
    MyFingerPinky
} MyFinger;
```

###4.3 Custom Constructors

**Preferred**

```objective-c
- (instancetype)initWithType:(NSString *)type;
+ (instancetype)sharedManager;
```

**Not Preferred**

```objective-c
- (id)initWithType:(NSString *)type;
+ (id)sharedManager;
```

###4.4 Literals
Since `NSString`, `NSDictionary`, `NSArray`, and `NSNumber` are immutable, use `@""`, `@{}`, `@[]`, and `@()` respectively when declaring a new instance;

**Preferred**

```objective-c
NSString *lastName = @"Dela Cruz";
NSDictionary *grades = @{"English":  @90, @"Math": @90, @"Science": @90};
NSArray *smartphoneBrands = @[@"Apple", @"Samsung", @"Lenovo", @"LG"];
NSNumber *hidden = @YES;
NSNumber *year = @2014;
```

**Not Preferred**

```objective-c
NSDictionary *grades = [NSDictionary dictionaryWithObjectsAndKeys:@90, @"English", @90, @"Math", @90, @"Science", nil];
NSArray *smartphoneBrands = [NSArray arrayWithObjects:@"Apple", @"Samsung", @"Lenovo", @"LG"];
NSNumber *hidden = [NSNumber numberWithBool:YES];
NSNumber *year = [NSNumber numberWithInteger:2014];
```

###4.5 Constants
Constants should be declared as `static` constants and not `#define` unless explicitly being used as macros. The start of the letter should be letter `k`

**Preferred**

```objective-c
static const NSString *kCompanyName = @"Ekek";
static const CGFloat kViewHeight = 100.0f;
```

**Not Preferred**

```objective-c
#define kCompanyName @"Ekek"
#define kViewHeight 100.0f
static CGFloat const ViewWidth = 19.0f;
```

###4.6 Singleton
Singleton objects should use a thread-safe pattern for creating their shared instance.

**Preferred**

```objective-c
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
```

###4.7 Private Methods and Variables
All private methods and variables should be declared in the implementation file under a class extension. Private variables must be treated as properties.

**Preferred**

```objective-c
// header file
@interface MYPerson : NSObject
...
@end

// implementation file
@interface MYPerson ()

@property (strong, nonatomic) NSString *foo;
@property (readwrite, nonatomic) CGFloat bar;

- (void)hibernate;
- (void)clap;

@end

@implementation MYPerson 
...
@end
```

**Not Preferred**

```objective-c
// header file
@interface MYPerson : NSObject
...
@end

// implementation file
@interface MYPerson () {
    NSString *_foo;
    CGFloat _bar;
}

- (void)hibernate;
- (void)clap;

@end

@implementation MYPerson 
...
@end
```

###5. Custom Views
When creating custom views like a subclass of `UITableViewCell`, do not expose publicly a subview such as `UILabel` if only the property `text` is being modified unless that subview requires heavy modification such as the `backgroundColor`, `font`, `textColor`, etc.

Instead of putting the property in the `.h` file, create a class extension in the `.m` file and declare the property. Create a `nonatomic` property in the `.h` file for the default setters and getters, which are implemented in the `.m` file, for the attribute to be modified.

**Preferred**

```objective-c
// MYTableViewCell.h
@interface MYTableViewCell : UITableViewCell

@property (nonatomic) NSString *username;

@end

// MYTableViewCell.m
@interface MYTableViewCell ()

@property (strong, nonatomic) UILabel *usernameLabel;

@end

@implementation MYTableViewCell ()

- (NSString *)username {
    return self.usernameLabel.text;
}

- (void)setUsername:(NSString *)username {
    self.usernameLabel.text = username;
}

@end
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
