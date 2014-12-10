//
//  Constants.h
//  CardWiser
//
//  Created by Andy Boariu on 27/03/14.
//  Copyright (c) ProtovateLLC. All rights reserved.
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// ******** API Keys**********************************
#define API_KEY_LINKEDIN              @"75vm02yj08bx27";
#define API_SECRETKEY_LINKEDIN        @"I7phOkuoVtGok0r1";

#define API_KEY_GOOGLEPLACES          @"AIzaSyBU469ZQFhOC4AuvPBPp_PEbgnX5C-Jblo"

#define isIpad                      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define isIphone                    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define isIphone_5                   ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define appDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define serviceManager [ServiceManager sharedManager]
#define appSharedData [AppSharedData sharedInstance]
#define userDefaults [NSUserDefaults standardUserDefaults]

#define deviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define deviceHeight ([[UIScreen mainScreen] bounds].size.height)

//*>    Define macros for FONT

#define Default_Font [UIFont fontWithName:@"Helvetica Neue" size:17.0]

//*>    Define macros for color
#define App_Theme_Color                [UIColor colorWithRed:19/255.0 green:143/255.0 blue:210/255.0 alpha:1.0]
#define White_Color                    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define Light_Gray_Color               [UIColor colorWithRed:111.0/255.0 green:113.0/255.0 blue:121.0/255.0 alpha:1.0]

//********************** Base URL Define Here ********************

#define BASE_URL                     @"http://192.168.0.166/cityhour/index.php/api/"

//********************** After Base URL Define Here ********************

#define WEB_URL_GetIndustry                             @"auth/GetIndustry"
#define WEB_URL_SignUp                                  @"auth/signup"
#define WEB_URL_CheckSocialMember_Exist                 @"auth/CheckSocialMemberExist"
#define WEB_URL_Login                                   @"auth/Login"
#define WEB_URL_Find_People                             @"profile/findpeople"
#define WEB_URL_Logout                                  @"auth/Logout"

//********************** Enum Define Here ********************
typedef NS_ENUM(NSUInteger, TaskType) {
    kTaskSignUp,
    kTaskCreateMeeting,
    kTaskGetMeetingTopic,
    kTaskUsersProfileData,
    kTaskFindPeople,
    kTaskGetIndustry,
    kTaskSendInvitation,
    kTaskGetMeetingList,
    kTaskAcceptViewUpdate,
    kTaskRespondToInvitation,
    kTaskSendMessage,
    kTaskGetMessages,
    kTaskDeleteInvitation,
    kTaskLogout,
    kTaskNearByPlaces,
    kTaskSearchAllPlaces,
    kTaskUpdateUserProfile,
    kTaskBlockMember,
    kTaskDeleteMeeting
};

// Enum For UserType
typedef NS_ENUM(NSUInteger, UserType){
    UserTypeSelf = 0,
    UserTypeOther = 1
};