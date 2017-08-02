//
//  scanDeviceTableViewController.h
//  bR500Sample
//
//  Created by ftsafe on 16/1/20.
//  Copyright (C)2016-2020 Feitian Technologies Co. ,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainViewController.h"

@interface scanDeviceTableViewController : UITableViewController<ReaderInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *deviceListArray;
@property (nonatomic,strong) ReaderInterface *readerInfo;
@property (nonatomic,strong) NSString *selectReaderName;

@end
