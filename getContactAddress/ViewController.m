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
}

@end
