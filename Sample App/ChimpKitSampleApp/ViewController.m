//
//  ViewController.m
//  ChimpKitSampleApp
//
//  Created by Drew Conner on 1/7/13.
//  Copyright (c) 2013 MailChimp. All rights reserved.
//

#import "ViewController.h"
#import "ChimpKit.h"
#import "CKSubscribeAlertView.h"
#import "CKScanViewController.h"


@implementation ViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
		
	// This call fetches lists
    [[ChimpKit sharedKit] callApiMethod:@"lists/list"
							 withParams:nil
				   andCompletionHandler:^(ChimpKitRequest *request, NSError *error) {
					   NSLog(@"Here are my lists: %@", request.responseString);
				   }];
}


#pragma mark - UI Actions

- (IBAction)subscribeButtonTapped:(id)sender {
	CKSubscribeAlertView *alert = [[CKSubscribeAlertView alloc] initWithTitle:@"Subscribe"
                                                                  message:@"Enter your email address to subscribe to our mailing list."
                                                                   listId:@"<YOUR LIST ID>"
                                                        cancelButtonTitle:@"Cancel"
                                                     subscribeButtonTitle:@"Subscribe"];
	
	[alert show];
}

- (IBAction)loginButtonTapped:(id)sender {
//	CKAuthViewController *authViewController = [[CKAuthViewController alloc] initWithClientId:@"<YOUR CLIENT ID>"
//																			  andClientSecret:@"<YOUR CLIENT SECRET>"];
	
	CKAuthViewController *authViewController = [[CKAuthViewController alloc] initWithClientId:@"754203189816"
																			  andClientSecret:@"b719f7cadac146743c177bd41eaf742b"];
	
	authViewController.enableMultipleLogin = YES;
	
    authViewController.delegate = self;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authViewController];
	
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)scanBarcodeButtonTapped:(id)sender {
	CKScanViewController *scanViewController = [[CKScanViewController alloc] init];
	
	[scanViewController setApiKeyFound:^(NSString *apiKey) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
															message:[NSString stringWithFormat:@"API Key: %@", apiKey]
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		
		[self dismissViewControllerAnimated:YES completion:^{
			[alertView show];
		}];
	}];
	
	[scanViewController setUserCancelled:^{
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:scanViewController];
	
	[self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - <CKAuthViewControllerDelegate> Methods

- (void)ckAuthUserCanceled {
	NSLog(@"Auth Cancelled");
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ckAuthSucceededWithApiKey:(NSString *)apiKey andAccountData:(NSDictionary *)accountData {
	NSLog(@"%@", accountData);
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ckAuthFailedWithError:(NSError *)error {
	NSLog(@"Auth Failed: %@", [error description]);
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
