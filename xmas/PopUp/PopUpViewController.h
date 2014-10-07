//
//  PopUpViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PopUpParameters.h"
#import "XMasBaseViewController.h"

@protocol PopUpDelegate <NSObject>
- (void)close;
- (void)showPage:(NSInteger)pageToShow isPrev:(BOOL)prev;

@end

@interface PopUpViewController : XMasBaseViewController
+ (id)instantiatePageNumber:(PopUpParameters *)param delegate:(id<PopUpDelegate>)aDeletegate;
@property (assign, nonatomic, readonly) NSInteger curentPage;

@end
