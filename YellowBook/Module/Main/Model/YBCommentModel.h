//
//  YBCommentModel.h
//  YellowBook
//
//  Created by forrest on 2022/1/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBCommentModel : NSObject

@property (nonatomic, copy, nullable) NSString *commentTitle;

@property (nonatomic, copy, nullable) NSString *commentContent;

@end

NS_ASSUME_NONNULL_END
