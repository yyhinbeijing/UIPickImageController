//
//  ViewController.m
//  UIPickImageController
//
//  Created by 阳永辉 on 16/3/9.
//  Copyright © 2016年 HuiDe. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>{
    
}
@property (nonatomic,strong)UIImagePickerController *imagePicker;

@end

@implementation ViewController
@synthesize imagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 100, 30, 30);
    button.titleLabel.text = @"中国";
    [button addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showImage {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
//    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];这句话也行
    imagePicker.videoMaximumDuration = 30.0f;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePicker.showsCameraControls = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
        NSURL *url=[editingInfo objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
//            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
//            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
//        }
//    
//   }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group,BOOL *stop) {
        if (group.numberOfAssets >0) {
            NSIndexSet *videoSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, group.numberOfAssets)];
            [group enumerateAssetsAtIndexes:videoSet options:0 usingBlock:^(ALAsset *result,NSUInteger index,BOOL *stop){
                ALAssetRepresentation *representation = [result defaultRepresentation];
                NSString *savingPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",representation.filename];
                [[NSFileManager defaultManager] createDirectoryAtPath:savingPath withIntermediateDirectories:nil attributes:nil error:nil];
                NSFileHandle *writingHandle = [NSFileHandle fileHandleForWritingAtPath:savingPath];
            }];
        }
    }failureBlock:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
//- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
//        
//        NSLog(@"%@",videoPath);
//        
//        NSLog(@"%@",error);
//        
// }
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
