//
//  ViewController.m
//  MQTT-iOS
//
//  Created by guohaitao on 2018/3/6.
//  Copyright © 2018年 blog.devhitao.com . All rights reserved.
//

#import "ViewController.h"

#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>

@interface ViewController ()<MQTTSessionManagerDelegate>
@property (nonatomic, strong) MQTTSessionManager * manager;

@property (weak, nonatomic) IBOutlet UITextField *topicTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *disconnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UITextView *txtVw;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadSetting];
}
#pragma mark 配置
- (void)loadSetting{
    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;

//        self.manager.subscriptions = [NSDictionary dictionaryWithObjectsAndKeys:@(0),@"iosdevice", @"0", @"1/2/3", @"0",@"top/#", nil];

//        [self.manager connectTo:@"sdkiot.mqtt.iot.bj.baidubce.com" port:1883 tls:NO keepalive:60 clean:true auth:true user:@"sdkiot/iosdevice001" pass:@"0hkdBjuVYpWDvJttr6RqUudzmVienmNPApuET4naFRw=" will:false willTopic:nil willMsg:nil willQos:0 willRetainFlag:false withClientId:@"3b760fd0173c4e0aafc349f2c85b1"];

        self.manager.subscriptions = [NSDictionary dictionaryWithObjectsAndKeys:@(0),@"get/#", nil];
        //抄表
                [self.manager connectTo:@"sdkiot.mqtt.iot.bj.baidubce.com" port:1883 tls:NO keepalive:60 clean:true auth:true user:@"sdkiot/chaobiaozhuji" pass:@"HZZTQG5bKwY5xkHh5Zi39IfO3/oM+TIf0XWlEROcX4o=" will:false willTopic:nil willMsg:nil willQos:0 willRetainFlag:false withClientId:@"3b60fd0173c4e0aafc349f2c85b1"];
        
//        sdkiot/chaobiaozhuji
//        HZZTQG5bKwY5xkHh5Zi39IfO3/oM+TIf0XWlEROcX4o=
        
//        sdkiot/dianbiao007
//        TDqfXCfYxYdIbSh0w9tsxRresWB1ec6YDYN6NpJCfrY=
        
//        sdkiot/dianbiao008
//        1aueyCyHUBIdwtTq+gWIq+W81LAocK25cjWfDIcC/p0=
        
        
    }else{
        [self.manager connectToLast];
    }
    
    [self.manager addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
            NSLog(@"Closed");
            break;
        case MQTTSessionManagerStateClosing:
            NSLog(@"Closing");
            break;
        case MQTTSessionManagerStateConnected:
            NSLog(@"Connected");
            break;
        case MQTTSessionManagerStateConnecting:
            NSLog(@"Connecting");
            break;
        case MQTTSessionManagerStateStarting:
            NSLog(@"Starting");
            break;
        default:
            NSLog(@"default");
            break;
    }
}

- (IBAction)connectTarget:(UIButton *)sender {
    [self.manager connectToLast];
}
- (IBAction)sendMessageTarget:(UIButton *)sender {
    if (self.topicTF.text == nil || [self.topicTF.text isEqualToString:@""]) {
        return;
    }
    if (self.messageTF.text == nil) {
        self.messageTF.text = @"";
    }
    [self.manager sendData:[self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding] topic:self.topicTF.text qos:1 retain:false];
}
- (IBAction)disconnectTarget:(UIButton *)sender {
    [self.manager disconnect];
}
- (IBAction)pubTarget:(UIButton *)sender {
    
}
- (IBAction)subTarget:(UIButton *)sender {
    
}


#pragma mark MQTTSessionManagerDelegate
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    NSString * bodyMessage = [NSString stringWithFormat:@"topic: %@ \n body:%@", topic, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    NSString * oldTxt = self.txtVw.text;
    self.txtVw.text = [NSString stringWithFormat:@"\n%@\n%@", bodyMessage, oldTxt];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
