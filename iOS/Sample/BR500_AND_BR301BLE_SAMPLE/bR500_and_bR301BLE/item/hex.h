//
//  hex.h
//  bR500Sample
//
//  Created by ftsafe on 16/1/21.
//  Copyright (C)2016-2020 Feitian Technologies Co. ,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Copyright(C) Feitian Technologies Co., Ltd. All rights reserved.
 * FileName:        hex.h
 * FileIdentify:    hex.h
 * Description:     data switch
 * Version:         1.9.3
 * Created by:      shanshan
 * FinishDate:      2016-01-21
 * Revision1:
 **/

@interface hex : NSObject
+(NSData *)hexFromString:(NSString *)cmd;
void StrToHex(unsigned char *pbDest, char *szSrc, unsigned int dwLen);
int filterStr(char *szSrc, unsigned int dwLen);
@end
