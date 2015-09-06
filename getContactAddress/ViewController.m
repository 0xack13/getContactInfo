//
//  ViewController.m
//  getContactAddress
//
//  Created by 0xack13 on 12/28/14.
//  Copyright (c) 2014 0xack13. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize firstName, phoneNumber;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender {
    NSLog(@"Button clicked!");
    [self addressBookValidation ];
    
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];

}

/* NEW!!
 - (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:peoplePicker completion:nil];

}*/

/* NEW
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    //[//self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:peoplePicker completion:nil];

    return NO;
}*/



- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phoneID = ABMultiValueCopyValueAtIndex(phone, 0);
    //phoneNumberTextField.text = [NSString stringWithFormat:@"%@", phoneID];
    CFRelease(phoneID);
    CFRelease(phone);
    [self displayPerson:person];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addContactFromPhoneContacts:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)addressBookValidation
{
    
    
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);//ABAddressBookCreate();
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error)
                                                     {
                                                         accessGranted = granted;
                                                         dispatch_semaphore_signal(sema);
                                                     });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            //dispatch_release(sema);
        }
        else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            accessGranted = YES;
        }
        else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusDenied)
        {
            accessGranted = NO;
        }
        else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusRestricted){
            accessGranted = NO;
        }
        else
        {
            accessGranted = YES;
        }
        
        
    }
    else
    {
        accessGranted = YES;
    }
    [prefs setBool:accessGranted forKey:@"addressBook"];
    
    NSLog(@"[prefs boolForKey:@'addressBook']--->%d",[prefs boolForKey:@"addressBook"]);
    [prefs synchronize];
    CFRelease(addressbook);
}

/*- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}*/

//Display method
- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    //Working on ios8  
    self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}


@end
