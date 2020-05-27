//
//  GlassViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 1/8/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//

NSString * const tokenUrl = @"http://202.59.231.107:8080/messaging/rest/v0/service/getToken";
#define kBackgroundColor_BarTintColor [UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0]
NSString * const glassViewUrl =  @"http://202.59.231.107:8080/messaging/index.jsp?token=%@";
#define kBackgroundColor_header [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0]

NSString * const sampleUrl = @"samples/4_Obtain$Poi$Data_2_From$Local$Resource/index.html";


#import "GlassViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface GlassViewController ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

{
    NSURLConnection *connection;
}
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation GlassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//kBackgroundColor_header;
    [self fetchTokenWithJsonData:self.jsonData];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _jsonData = nil;
    _currentLocation = nil;
    connection = nil;
    _responseData = nil;
}

-(void)fetchTokenWithJsonData:(NSString *)jsonData
{
    NSMutableString *uri = [NSMutableString stringWithString:tokenUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    
    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    
    NSString *postString = [NSString stringWithFormat:@"data=%@&latitude=%@&longitude=%@", jsonData,latitude,longitude];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:jsonData forKey:@"data"];
    [postDict setValue:latitude forKey:@"latitude"];
    [postDict setValue:longitude forKey:@"longitude"];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Starting connection: %@ for request: %@", connection, request);
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)createUrl:(NSString *)token
{
    //    NSString *urlStr = [NSString stringWithFormat:@"http://202.59.231.107:8080/messaging/index.jsp?token=%@",token];
    CIImage *image = [self createQRForString:sampleUrl];
    UIImage *qrImage = [UIImage imageWithCIImage:image];//[self createNonInterpolatedUIImageFromCIImage:image withScale:5*[[UIScreen mainScreen] scale]];
    UIImageView *qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 250, 250)];
    qrCodeImageView.image = qrImage;
    
    [self.view addSubview:qrCodeImageView];
    
}


#pragma mark - QR Code Scanning Methods

- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
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
    NSString *token = [object valueForKey:@"token"];
    [self createUrl:token];
    NSLog(@"Token = %@",token);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@",error);
    
    [self createUrl:nil];
    
}

@end
