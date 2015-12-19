
/**
 *
 */
#import "Users.h"

@implementation Users
- (instancetype)init
{
    self = [super init];
    if (self) {
        _propertyArrayMap = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"User", @"list", nil];
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
        _page = [NSNumber numberWithInteger:1];
        _pageSize = [NSNumber numberWithInteger:9999];
    }
    return self;
}

+(Users *)usersWithOwner:(UserInstance *)owner Type:(UsersType)type{
    Users *users = [[Users alloc] init];
    users.owner = owner;
    users.type = type;
    return users;
}

- (NSString *)toPath{
    NSString *path;
    if (_type == UsersTypeFollowers) {
        path = @"api/user/followers";
    }else if (_type == UsersTypeFriends_Message || _type == UsersTypeFriends_Attentive || _type == UsersTypeFriends_At || _type == UsersTypeFriends_Transpond){
        path = @"api/user/friends";
    }
    if (_owner && _owner.global_key) {
        path = [path stringByAppendingFormat:@"/%@", _owner.global_key];
    }
    return path;
}

- (NSDictionary *)toParams{
    return @{@"page" : (_willLoadMore? [NSNumber numberWithInteger:_page.intValue+1] : [NSNumber numberWithInteger:1]),
             @"pageSize" : _pageSize};
}

- (void)configWithObj:(Users *)resultA{
    self.page = resultA.page;
    self.pageSize = resultA.pageSize;
    self.totalPage = resultA.totalPage;
    self.totalRow = resultA.totalRow;
    if (_willLoadMore) {
        [self.list addObjectsFromArray:resultA.list];
    }else{
        self.list = [NSMutableArray arrayWithArray:resultA.list];
    }
    self.canLoadMore = self.page.intValue < self.totalPage.intValue;
}

- (NSDictionary *)dictGroupedByPinyin{
    if (self.list.count <= 0) {
        return @{@"#" : [NSMutableArray array]};
    }
    
    NSMutableDictionary *groupedDict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *allKeys = [[NSMutableArray alloc] init];
    for (char c = 'A'; c < 'Z'+1; c++) {
        char key[2];
        key[0] = c;
        key[1] = '\0';
        [allKeys addObject:[NSString stringWithUTF8String:key]];
    }
    [allKeys addObject:@"#"];
    
    for (NSString *keyStr in allKeys) {
        [groupedDict setObject:[[NSMutableArray alloc] init] forKey:keyStr];
    }
  
  
    [self.list enumerateObjectsUsingBlock:^(UserInstance *obj, NSUInteger idx, BOOL *stop) {
        NSString *keyStr = nil;
        NSMutableArray *dataList = nil;
        
        if (obj.pinyinName.length > 1) {
            keyStr = [obj.pinyinName substringToIndex:1];
            if ([[groupedDict allKeys] containsObject:keyStr]) {
                dataList = [groupedDict objectForKey:keyStr];
            }
        }
        
        if (!dataList) {
            keyStr = @"#";
            dataList = [groupedDict objectForKey:keyStr];
        }
        
        [dataList addObject:obj];
        [groupedDict setObject:dataList forKey:keyStr];
    }];
    
    for (NSString *keyStr in allKeys) {
        NSMutableArray *dataList = [groupedDict objectForKey:keyStr];
        if (dataList.count <= 0) {
            [groupedDict removeObjectForKey:keyStr];
        }else if (dataList.count > 1){
            [dataList sortUsingComparator:^NSComparisonResult(UserInstance *obj1, UserInstance *obj2) {
                return [obj1.pinyinName compare:obj2.pinyinName];
            }];
        }
    }
    
    return groupedDict;
}
@end
