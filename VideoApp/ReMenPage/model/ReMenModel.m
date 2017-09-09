
//
//  ReMenModel.m
//  VideoApp
//
//  Created by 叶健东 on 17/2/13.
//  Copyright © 2017年 www.huirenshi.com. All rights reserved.
//

#import "ReMenModel.h"
#import "ReMenText.h"
#import "ReMenVoice.h"


@implementation ReMenModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comment_t" : [ReMenText class],
             @"comment_c" : [ReMenVoice class]};
}


-(CGFloat)cellHeight {
    if (self.comment_t.count==0 && self.comment_c.count==0) {
        _cellHeight=KScreenHeight*0.4741+4;
    }
    if (self.comment_t.count==1 && self.comment_c.count<2) {
        _cellHeight=KScreenHeight*0.595+4;
    }
    if (self.comment_t.count<2 && self.comment_c.count==1) {
        _cellHeight=KScreenHeight*0.595+4;
    }
    // 两个评论
    
    if (self.comment_t.count==2 && self.comment_c.count<3) {
          _cellHeight=KScreenHeight*0.655+4;
    }
    if (self.comment_t.count<3 && self.comment_c.count==2) {
        _cellHeight=KScreenHeight*0.655+4;
    }
    // 3个及以上评论
    if (self.comment_t.count>2 || self.comment_c.count>2) {
        _cellHeight=KScreenHeight*0.705+4;
    }
    return _cellHeight;
}
@end
