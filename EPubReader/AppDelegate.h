//
//  AppDelegate.h
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow* _window;
    MasterController* masterController;
}

@property (strong, nonatomic) UIWindow *window;

@end
