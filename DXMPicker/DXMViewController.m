//
//  ViewController.m
//  DXMPicker
//
//  Created by YANGJINMING on 16/3/17.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import "DXMViewController.h"
#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface DXMViewController ()<CameraViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    //拍照
    CameraView *_cameraView;
    NSInteger imageCount;
}
@property(nonatomic,strong)NSMutableArray *imageAy;
@end

@implementation DXMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //拍照
    _cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 105) Delegate:self];
    [self.view addSubview:_cameraView];
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentSize"]) {
        NSInteger J = (Screen_Width-JZWGap)/ImageWH;
        float hitg = (_cameraView.collectionAr.count/J)*65+30;
        if (_cameraView.collectionAr.count%J != 0) {
            hitg = (_cameraView.collectionAr.count/J +1)*65+30;
        }
        _cameraView.cameraCollectionV.frame = CGRectMake(_cameraView.cameraCollectionV.frame.origin.x, _cameraView.cameraCollectionV.frame.origin.y, _cameraView.cameraCollectionV.frame.size.width, hitg);
        CGRect rect = _cameraView.frame;
        rect.size.height = hitg+10;
        _cameraView.frame = rect;
        _cameraView.linedown.frame = CGRectMake(0, _cameraView.frame.size.height -0.5, Screen_Width, 0.5);
        
//        [self layoutScrollSubview];
    }
}
-(void)uploadPic {
    UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"从手机相册中选择",@"拍照上传", nil];
    ac.tag = 101;
    [ac showInView:self.view];
}
#pragma mark - CameraViewDelegate
- (void)clickCollectionViewCellCamera {
    [self uploadPic];
}
- (void)deleteRowsAtIndexPaths:(NSDictionary *)dic {
    NSNumber *number = [dic objectForKey:@"Index"];
    [self.imageAy removeObject:[self.imageAy objectAtIndex:number.intValue]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIActionSheetDelegate
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex])
        return;
    //只是拍照
    //    _infotype = 1;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (buttonIndex) {
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])  {
                UIImagePickerController *imageVC = [[UIImagePickerController alloc]init];
                imageVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imageVC.allowsEditing = NO;
                imageVC.delegate = self;
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                    imageVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:imageVC animated:YES completion:nil];
            }
        }
            break;
        case 1: {
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//                [UIAlertView showAlertView:@"无法使用相机" Message:@"请在iPhone的“设置-隐私-相机”中允许访问相机"];
                return;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imageVC = [[UIImagePickerController alloc]init];
                imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                imageVC.allowsEditing = NO;
                imageVC.delegate = self;
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                    imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self presentViewController:imageVC animated:YES completion:nil];
                });
            }
            else
            {
                [MBProgressHUD showHUDtoDiss:@"无照相设备" ToView:self.view];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //模态方式退出uiimagepickercontroller
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
            NSString *imagename = [NSString stringWithFormat:@"IMG%@.png",dateString];
            [self saveImage:image WithName:imagename];
        }
    });
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //模态方式退出uiimagepickercontroller
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    //设置image的尺寸
    if (tempImage.size.width > 1000) {
        CGSize imagesize = tempImage.size;
        CGFloat scale = imagesize.height/imagesize.width;
        imagesize.width = 1000;
        imagesize.height  = 1000*scale;
        tempImage = [tempImage clipImageWithScaleWithsize:imagesize];
    }
    if (self.imageAy.count == 0) {
        self.imageAy = [[NSMutableArray alloc]init];
    }
    [self.imageAy addObject:tempImage];
    NSDictionary *dic = @{@"Image":tempImage};
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:dic waitUntilDone:YES];
}
- (void)updateUI:(NSDictionary *)dic {
    NSMutableArray *imageAr = [NSMutableArray arrayWithArray:_cameraView.collectionAr];
    [imageAr insertObject:dic atIndex:_cameraView.collectionAr.count-1];
    imageCount++;
    if (imageCount == 1) {
        [_cameraView.cameraCollectionV addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
    }
    _cameraView.collectionAr = imageAr;
    [_cameraView.cameraCollectionV reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
