//
//  WFFilterViewController.m
//  WellsFargoProject
//
//  Created by Ruptapas Chakraborty on 1/1/15.
//  Copyright (c) 2015 Synechron. All rights reserved.
//

#import "WFFilterViewController.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kMenuSelectedColor [UIColor colorWithRed:180.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0]
#define kMenuTableTextColor [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0]
#define kMenuTableSelectedTextColor [UIColor colorWithRed:31.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0]
@interface WFFilterViewController ()<UITableViewDelegate>{
    NSArray *garrMenuItems;
    NSArray *garrMenuDetailsItems;
    NSArray *garrMenuDetailsItemsForRevenue;
    NSArray *garrMenuDetailsItemsForOptions;
    NSInteger gIntSelectedIndex,gIntSelectedMenuDetailIndex;
}

@end

@implementation WFFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    garrMenuItems = @[@"Revenue", @"Option 1", @"Option 2",
                      @"Option 3"];
    garrMenuDetailsItemsForRevenue = @[@"$50Million - $100Million",@"$100Million - $500Million",@"$500Million - $1Billion",@"$1Billion - $5Billion",@"$5Billion - $20Billion"];
    garrMenuDetailsItems = garrMenuDetailsItemsForRevenue;
    garrMenuDetailsItemsForOptions = @[@"1", @" 2", @"3"];
    self.filterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.filterView.layer.borderWidth = 1.0f;
    self.menuTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menuTableView.layer.borderWidth = 1.0f;
    self.menuDetailTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menuDetailTableView.layer.borderWidth = 1.0f;
    gIntSelectedIndex = -1;
    gIntSelectedMenuDetailIndex = -1;
    [self handleLayoutsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    [self.doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchDragInside];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    gIntSelectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:gIntSelectedIndex inSection:0];
    [self tableView:self.menuTableView didSelectRowAtIndexPath:selectedIndexPath];
}

-(IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.menuDetailTableView) {
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHeight;
    if (tableView == self.menuTableView) {
        rowHeight = 100;
    }else if (tableView == self.menuDetailTableView){
        if (indexPath.section==0) {
            rowHeight = 60;
        }else if(indexPath.section == 1){
            rowHeight = 100;
        }
    }
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numberOfSections = 0;
    if (tableView == self.menuTableView) {
        numberOfSections = 1;
    }else if (tableView == self.menuDetailTableView){
        numberOfSections = 2;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger intRowCount=0;
    if (tableView == self.menuTableView) {
        intRowCount = [garrMenuItems count];
    }else if (tableView == self.menuDetailTableView){
        if (section==0) {
            intRowCount = [garrMenuDetailsItems count];
        }else if(section == 1){
            intRowCount = 1;
        }
        
    }
    return intRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == self.menuTableView) {
        if (cell == nil) {
            static NSString *cellIdentifier = @"CellMenu";
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = [garrMenuItems objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if (gIntSelectedIndex ==indexPath.row) {
                cell.contentView.backgroundColor = kMenuSelectedColor;
                cell.textLabel.textColor = [UIColor whiteColor];
            }
            if (IS_IPAD) {
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
            }else{
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            }
            
        }
    }else if (tableView == self.menuDetailTableView){
        if (indexPath.section==0) {
            if (cell == nil) {
                static NSString *cellIdentifier = @"CellMenuDetail";
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.textLabel.text = [garrMenuDetailsItems objectAtIndex:indexPath.row];
                cell.imageView.image = [UIImage imageNamed:@"unchecked"];
                if (gIntSelectedMenuDetailIndex ==indexPath.row) {
                    cell.imageView.image = [UIImage imageNamed:@"check"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                if (IS_IPAD) {
                    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
                }else{
                    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                    cell.textLabel.numberOfLines =2;
                }
            }
        }else if(indexPath.section == 1){
            // Code for Custom Slider
            if (cell == nil) {
                static NSString *cellIdentifier = @"CellMenuDetail";
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.menuTableView) {
        UITableViewCell *cell;
        
        //Clear data
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:gIntSelectedMenuDetailIndex inSection:0];
        cell = [self.menuDetailTableView cellForRowAtIndexPath:selectedIndexPath];
        cell.imageView.image = [UIImage imageNamed:@"unchecked"];
        gIntSelectedMenuDetailIndex = -1;
        self.lblSummary.text = [NSString stringWithFormat:@"Revenue: "];
        
        selectedIndexPath = [NSIndexPath indexPathForRow:gIntSelectedIndex inSection:0];
        cell = [self.menuTableView cellForRowAtIndexPath:selectedIndexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kMenuTableTextColor;
        
        cell = [self.menuTableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = kMenuSelectedColor;
        cell.textLabel.textColor = [UIColor whiteColor];
        //kMenuTableSelectedTextColor;
        //        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        gIntSelectedIndex = indexPath.row;
        if (gIntSelectedIndex == 0) {
            garrMenuDetailsItems = garrMenuDetailsItemsForRevenue;
        }else{
            garrMenuDetailsItems = garrMenuDetailsItemsForOptions;
        }
        [self.menuDetailTableView reloadData];
    }else if (tableView == self.menuDetailTableView){
        if (gIntSelectedIndex == 0) {
            if (indexPath.section==0) {
                
                UITableViewCell *cell;
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:gIntSelectedMenuDetailIndex inSection:0];
                cell = [self.menuDetailTableView cellForRowAtIndexPath:selectedIndexPath];
                cell.imageView.image = [UIImage imageNamed:@"unchecked"];
                
                cell = [self.menuDetailTableView cellForRowAtIndexPath:indexPath];
                cell.imageView.image = [UIImage imageNamed:@"check"];
                gIntSelectedMenuDetailIndex = indexPath.row;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                self.lblSummary.text = [NSString stringWithFormat:@"Revenue: %@",cell.textLabel.text];
            }else if(indexPath.section == 1){
                // Code for Custom Slider
                
            }
            
        }else{
            //Options Code here
            UITableViewCell *cell;
            
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:gIntSelectedMenuDetailIndex inSection:0];
            cell = [self.menuDetailTableView cellForRowAtIndexPath:selectedIndexPath];
            cell.imageView.image = [UIImage imageNamed:@"unchecked"];
            
            cell = [self.menuDetailTableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"check"];
            gIntSelectedMenuDetailIndex = indexPath.row;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }else
    {
        
    }
}


-(NSMutableArray*)getAllItemsForFileName:(NSString*)fileName key:(NSString*)key{
    // NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    
    // serialize the request JSON
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *tempData = [NSData dataWithContentsOfFile:filePath];
    // NSDictionary *tempDict = [[NSDictionary alloc]init];
    
    NSDictionary *tempDict = [NSJSONSerialization
                              JSONObjectWithData:tempData
                              
                              options:kNilOptions
                              error:&error];
    
    NSMutableArray *arrTemp = [tempDict objectForKey:key];
    
    return arrTemp;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.menuTableView reloadData];
    [self.menuDetailTableView reloadData];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case 1:
        case 2:
            NSLog(@"portrait");
            // your code for portrait...
            if (!IS_IPAD) {
                self.menuTableWidthConstraint.constant = 80;
            }
            
            [self.view needsUpdateConstraints];
            break;
            
        case 3:
        case 4:
            NSLog(@"landscape");
            // your code for landscape...
            self.menuTableWidthConstraint.constant = 200;
            [self.view needsUpdateConstraints];
            break;
        default:
            NSLog(@"other");
            // your code for face down or face up...
            break;
    }
}

- (void)handleLayoutsForOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.menuTableView reloadData];
    [self.menuDetailTableView reloadData];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case 1:
        case 2:
            NSLog(@"portrait");
            // your code for portrait...
            if (!IS_IPAD) {
                self.menuTableWidthConstraint.constant = 80;
            }
            
            [self.view needsUpdateConstraints];
            break;
            
        case 3:
        case 4:
            NSLog(@"landscape");
            // your code for landscape...
            self.menuTableWidthConstraint.constant = 200;
            [self.view needsUpdateConstraints];
            break;
        default:
            NSLog(@"other");
            // your code for face down or face up...
            break;
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
