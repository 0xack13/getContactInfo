//
//  ViewController.h
//  getContactAddress
//
//  Created by 0xack13 on 12/28/14.
//  Copyright (c) 2014 0xack13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction)showPicker:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *firstName;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@end
