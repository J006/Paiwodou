

#import <Foundation/Foundation.h>
#import "UserInstance.h"

typedef NS_ENUM(NSInteger, UsersType) {
    UsersTypeFollowers = 0,
    UsersTypeFriends_Attentive,
    UsersTypeFriends_Message,
    UsersTypeFriends_At,
    UsersTypeFriends_Transpond,
    
    UsersTypeTweetLikers,
    UsersTypeAddToProject,
    UsersTypeAddFriend
};

@interface Users : NSObject
@property (readwrite, nonatomic, strong) NSNumber *page, *pageSize, *totalPage, *totalRow;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (readwrite, nonatomic, strong) NSDictionary *propertyArrayMap;
@property (readwrite, nonatomic, strong) NSMutableArray *list;//所有user的集合
@property (assign, nonatomic) UsersType type;
@property (strong, nonatomic) UserInstance *owner;

- (NSString *)toPath;
- (NSDictionary *)toParams;
- (void)configWithObj:(Users *)resultA;

- (NSDictionary *)dictGroupedByPinyin;

+(Users *)usersWithOwner:(UserInstance *)owner Type:(UsersType)type;
@end
