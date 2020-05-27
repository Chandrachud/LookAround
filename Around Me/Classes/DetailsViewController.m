//
//  DetailsViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "DetailsViewController.h"
#import "RootSplitViewController.h"
#import "SettingsModelClass.h"
#import "DropDownView.h"
#define citiesUrl = @"http://localhost:3000/cities";

@interface DetailsViewController ()<RightSplitViewControllerDelegate, UITableViewDataSource,UITableViewDelegate>
{
    UIView *revenueView;
    UISlider *maxValueSlider;
    UISlider *minValueSlider;
    UILabel *minValLbl;
    UILabel *maxValLbl;
    CGFloat height;
    UIButton *selectedBtn;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *arrayList;
@property(nonatomic, strong)NSIndexPath *lastIndexPath;
@property(nonatomic, strong)DropDownView *dropDownView;

@property(nonatomic, strong)NSArray *countriesList;
@property(nonatomic, strong)NSArray *statesList;
@property(nonatomic, strong)NSArray *cityList;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation DetailsViewController

-(void)viewDidLoad
{
    minValueSlider = [[UISlider alloc]init];
    maxValueSlider = [[UISlider alloc]init];
    [self.locationsView setHidden:YES];
    self.dropDownView = [[DropDownView alloc]init];
    height = 200;
    self.cityList = [NSArray arrayWithObjects:@"city",@"city1",@"city2",@"city3",@"city4", nil];
    
}

#pragma mark - Other Helpful Methods

-(void)createIndustriesView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.arrayList = [NSArray arrayWithObjects:@"Industry1",@"Industry1",@"Industry2",@"Industry3", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self fetchDataFromUrl:[NSURL URLWithString:@"http://localhost:3000/cities"]];
}
-(void)createRevenueSettings
{
    revenueView = [[UIView alloc]init];
    revenueView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    
    //Minumum Value Label
    UILabel *minlbl = [[UILabel alloc]init];
    minlbl.frame = CGRectMake(10, 40, 40, 30);
    minlbl.text = @"min";
    
    //Maximum Value Label
    UILabel *maxlbl = [[UILabel alloc]init];
    maxlbl.frame = CGRectMake(10, 80, 40, 30);
    maxlbl.text = @"max";
    
    minValLbl = [[UILabel alloc]initWithFrame:CGRectMake(revenueView.frame.size.width/1.5 + 50, 40, 50, 30)];
    maxValLbl = [[UILabel alloc]initWithFrame:CGRectMake(revenueView.frame.size.width/1.5 + 50, 80, 50, 30)];

    //Min Value slider
    minValueSlider.frame = CGRectMake(50, 40, revenueView.frame.size.width/1.5, 30);
    minValueSlider.minimumValue = 0;
    minValueSlider.maximumValue = 50;
    minValueSlider.tag =1;
    [minValueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    //Max Value slider
    maxValueSlider.frame = CGRectMake(50, 80, revenueView.frame.size.width/1.5, 30);
    maxValueSlider.maximumValue = 100;
    maxValueSlider.tag = 2;
    [maxValueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [revenueView addSubview:minValLbl];
    [revenueView addSubview:maxValLbl];
    [revenueView addSubview:maxlbl];
    [revenueView addSubview:minlbl];
    [revenueView addSubview:minValueSlider];
    [revenueView addSubview:maxValueSlider];
    [self.view addSubview:revenueView];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    NSLog(@"slider value = %f", sender.value);
    maxValueSlider.minimumValue = minValueSlider.value;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:0];
    
    NSString *minValue = [formatter stringFromNumber:[NSNumber numberWithDouble:minValueSlider.value]];
    NSString *maxValue = [formatter stringFromNumber:[NSNumber numberWithDouble:maxValueSlider.value]];

    minValLbl.text = [NSString stringWithFormat:@"%@",minValue];
    maxValLbl.text = [NSString stringWithFormat:@"%@", maxValue];
    
    [[SettingsModelClass sharedSettings] setRevenueFrom:minValueSlider.value];
    [[SettingsModelClass sharedSettings] setRevenueTo:maxValueSlider.value];
}


-(void)objectSelected:(NSInteger)index
{
   
    if (index == 0) {
        
        [self.tableView setHidden:YES];
        [revenueView setHidden:YES];
        [self.locationsView setHidden:YES];
    }
    else if(index == 1)
    {
        if (!self.tableView) {
            [self createIndustriesView];
        }
        [self.locationsView setHidden:YES];
        [revenueView setHidden:YES];
        [self.tableView setHidden:NO];
    }
    else if(index == 2)
    {
        [self.tableView setHidden:YES];
        if (!revenueView) {
            [self createRevenueSettings];
        }
        [revenueView setHidden:NO];
        [self.locationsView setHidden:YES];


    }   else if(index == 3)
    {
        [self.tableView setHidden:YES];
        [revenueView setHidden:YES];
        [self.locationsView setHidden:NO];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
   // [self.dropDownView hideDropDown:selectedBtn];
}
#pragma mark - IBAction Methods

-(void)countryBtnClicked:(id)sender
{
    [self.dropDownView showDropDown:self.countryButton height:&height arr:self.cityList imgArr:nil direction:@"down"];
    selectedBtn = self.countryButton;
}

-(void)stateBtnClicked:(id)sender
{
 [self.dropDownView showDropDown:self.stateButton height:&height arr:self.cityList imgArr:nil direction:@"down"];
    selectedBtn = self.stateButton;

}

-(void)cityBtnClicked:(id)sender
{
    [self.dropDownView showDropDown:self.cityButton height:&height arr:self.cityList imgArr:nil direction:@"down"];
    selectedBtn = self.cityButton;

}
#pragma mark - TableView Delegate and Data Sources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[SettingsModelClass sharedSettings] setIndustry:[self.arrayList objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[self.arrayList objectAtIndex:indexPath.row]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastIndexPath = indexPath;
    [tableView reloadData];
}

#pragma mark - Server Connection Methods

-(void)fetchDataFromUrl:(NSURL *)url

{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

#pragma mark - NSUrlConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(!_responseData) {
        _responseData = [NSMutableData dataWithData:data];
    } else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    id object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
    self.cityList = object;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
