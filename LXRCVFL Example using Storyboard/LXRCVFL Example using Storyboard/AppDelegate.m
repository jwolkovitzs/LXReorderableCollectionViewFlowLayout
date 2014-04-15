//
//  AppDelegate.m
//  LXRCVFL Example using Storyboard
//
//  Created by Stan Chang Khin Boon on 3/10/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "AppDelegate.h"
#import <dlfcn.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadReveal];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)loadReveal
{
#ifdef DEBUG
    NSString *dyLibPath = @"/Applications/Reveal.app/Contents/SharedSupport/iOS-Libraries/libReveal.dylib";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dyLibPath isDirectory:NULL])
    {
        NSLog(@"Loading dynamic library: %@", dyLibPath);
        
        void *revealLib = NULL;
        revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
        
        if (revealLib == NULL)
        {
            char *error = dlerror();
            NSLog(@"Reveal Library %@ failed to load with error: %s", [dyLibPath lastPathComponent], error);
        }
    }
    else
    {
        NSLog(@"Not loading Reveal framework!");
    }
#else
    NSLog(@"Skipping Reveal plugin for Release target.");
#endif
}

@end
