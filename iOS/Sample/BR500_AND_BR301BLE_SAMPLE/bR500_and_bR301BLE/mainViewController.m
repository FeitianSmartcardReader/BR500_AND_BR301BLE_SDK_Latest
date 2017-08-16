//
//  mainViewController.m
//  bR500Sample
//
//  Created by ftsafe on 16/1/20.
//  Copyright (C)2016-2020 Feitian Technologies Co. ,Ltd. All rights reserved.
//

#import "mainViewController.h"
#import "hex.h"

@interface mainViewController ()
{
    SCARDCONTEXT gContxtHandle;
    SCARDHANDLE  gCardHandle;
    NSArray *commandList;
    ReaderInterface *readerDescription;
}
@end

//1.9.6 - Modify connectPeripheralReader API and change demo code, set timeout t0 5s

#define SoftVersion @"1.9.6"
NSString *identifier = @"commandListView";

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCommandTableView];
    [self createReaderContext];
    [self createButtonItem];
    [self createFileSaveSeedBuffer];
    
    self.cardStatus.on = self.cardIsAttached;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  init tableview
 */
-(void)createCommandTableView
{
    //1.init UI
    [self.connectCardButton setTitle:NSLocalizedString(@"connectCardButtonTitle", nil) forState:UIControlStateNormal];
    [self.disConnectCardButton setTitle:NSLocalizedString(@"disconnectCardButtonTitle", nil) forState:UIControlStateNormal];
    [self.sendButton setTitle:NSLocalizedString(@"sendButtonTitle", nil) forState:UIControlStateNormal];
    [self.writeUIDButton setTitle:NSLocalizedString(@"writeUIDButtonTitle", nil) forState:UIControlStateNormal];
    [self.readUIDButton setTitle:NSLocalizedString(@"readUIDButtonTitle", nil) forState:UIControlStateNormal];
    [self.eraseUIDButton setTitle:NSLocalizedString(@"eraseUIDButtonTitle", nil) forState:UIControlStateNormal];
    [self.writeFlashButton setTitle:NSLocalizedString(@"writeFlashButtonTitle", nil) forState:UIControlStateNormal];
    [self.readFlashButton setTitle:NSLocalizedString(@"readFlashButtonTitle", nil) forState:UIControlStateNormal];
    [self.cardStatusButton setTitle:NSLocalizedString(@"cardStatusButtonTitle", nil) forState:UIControlStateNormal];
    [self.getSerialNumButton setTitle:NSLocalizedString(@"getSerialNumButtonTitle", nil) forState:UIControlStateNormal];
    
    [_commandListView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    commandList = [[NSArray alloc] initWithObjects:@"0084000008",@"0084000004", nil];
    
#if FT_TEST
    commandList = [[NSArray alloc] initWithObjects:@"0084000008",
                   @"java card command as follow:",
                   @"008400007F",
                   @"00A4040008D156000001010301",
                   @"00A40000023F00",
                   @"00e4010002a001",
                   @"00e00000186216820238008302a00185020000860800000000000000ff",
                   @"00A4000002A001",
                   @"00E00000186216820201018302B001850200ff86080000000000000000",
                   @"00D60000FA00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849",
                   @"00D60000FB0001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950",
                   @"00D60000FF000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354",
                   @"00b00000FF",
                   @"00A40000023F00",
                   @"00A4000002A001",
                   @"00e4020002B001",
                   @"00A40000023F00",
                   @"00e4010002a001",
                   @"ben_262 card as follow",
                   @"00a404000a01020304050607080900",
                   @"8010010600",
                   @"8020000001",
                   
                   @"80300000FB0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
                   //mAdapter1.add("80300000FA00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849"
                   @"8030000000010600010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061",
                   @"8010010600",
                   @"black-white type B",
                   @"00A404000BA000000291A00000019102",
                   @"00B201A420",
                   @"00B201AC40",
                   @"好的之扩展指令select app, write 128,read,write 250,read,write 256,read",
                   @"00A40400051122334455",
                   @"128bytes",
                   @"0001000080f22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74edb81635f5c3",
                   @"00020000",
                   @"250bytes",
                   @"00010000FAf22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74edb81635f5c3f22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74",
                   @"00020000",
                   @"256bytes",
                   @"00010000000100016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395",
                   @"00020000",
                   @"262bytes",
                   @"8030000000010600010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061",
                   @"00020000",
                   @"300bytes",
                   @"0001000000012Cff001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899",
                   @"00020000",
                   @"512bytes",
                   @"00010000000200016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395",
                   @"00020000",
                   @"1024bytes",
                   @"00010000000400016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395",
                   @"00020000",
                   @"2048bytes",
                   @"00010000000800016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395",
                   @"00020000",
                   @"好的之com",
                   @"00A40400050102030405",
                   @"8010007000",
                   @"8010012100",
                   @"好的之长返回",
                   @"00A404000A01020304050607080900",
                   @"80200000EE",
                   @"80200000EF",
                   @"80200000F0",
                   @"80200000F1",
                   @"80200000FE",
                   @"80200000FF",
                   @"801000e3000000",
                   @"802000000003e3",
                   @"801000f100",
                   @"好的之超时0--0x40",
                   @"00A404000A01020304050607081000",
                   @"8010000000",
                   @"8010000100",
                   @"8010000200",
                   @"8010000300",
                   @"8010004000",
                   @"Mifare 1k card",
                   @"FF82000106FFFFFFFFFFFF",
                   @"FF860000050100016000",
                   @"FFB0000210",
                   @"FFD600021011223344556677889900AABBCCDDEEFF",
                   @"FFD600021001000000FEFFFFFF0100000001FE01FE",
                   @"压力测试卡",
                   @"007700000004005198ACAA3574C9815E246CBA92328EB4BE9DB925D26A78BCD25B0D052AFF618C43EB41455346C62B798B1528098A493525B0AEC28D893058B783137D23F5E4D8E95FAF9594F4720B3255D29CACA00DDD54A930F7BD878A4ECF5360601A2CE2EF6B7E5E629D84B469B20C0AE0237BC0F67310A68E0A6D6DE541535C75BAAD441AF2D0B6741901738C213724BA15234CC6AC6E7A4D1E42C366360B6F86A87FF3A1A6DC2092AE7099BDA65F8AF32AA19796254A13FD9E0E7319D50402598FAAD6CCAE2A028604DB0D44690BA3530BFC8BAD062CD96635D9654647C57BB81537D4E23242C516C449B76993C3D7A1603C0F55789C344F89AC8135B3D64469E22DD72D5CADD20B96C37F744C108EA7D06A0AD4A3238C81428EAF2E42C0C3349F94C6F352F2902C21504DACBB78302B048C6673AE4849C50988D7781C0A62E3F474887D3C9966430EF8095A098525F6A4AD0A7AC194D3E186A1E15C683C883C88D60713432ABE1604C39BC65DBFD6D057D2DE31068E939D60E1B5224FDF9C0904C12AFD8F2EFF6FACBAEB38E0ADA980C505CADFA2BEEFC33F503B12F87A08100F3ED982472D9014AEE4E2F8BAD707D0974DB6CEC0AC5019CDF75C738B95331A5254FCEB93ADDBCDB14A664D12C5598675B38A4486E11F69AFDDFE8F32B885EE750B7C809C3847645DF260811000056B063D2E8A1CE4C279900A0AAC136C66561F6B3F898A553C9F5CE6B9DADE0F7547F3F58AE8AB3DA3111687691356383E18F87D2E4E858D2248532E57A1A17A0FE2E3E387A55B7528FBE95B010C24A575FDA9483117B4666225EDD0241D84CA3D037F0E0B0B5313BBFEB28EBCDEA53A73CDDAD4312B3F6A62FFD0D60798AC8666746F7EFF60BC9FC3E1192981D3007FA150322A14D34F218B9DA447E7584436F1FB5A3B4CEDBDA1A86DC53337315EFC654D5A51C4570C1245C9122CAEA672624861E94ED8FA7FA2D16A5FB4C841E63A288EFA5127FF9DC5F949C18C43CA5E93D26DC3BE8DCF2A2AA8A08EB51B4BC1C053D9B93327122AC20DE65B6F8E0C3250F7E9909352B3E5BF94D6FB3C189716164CF73FFEABDADD92EB6885DE77B413221F9BFAD50EF0D8EBFDD64E54A76C0EC57DB035BA9A9DDCBCF997E9DFE6092B90B24DA78DABCC2C354B662E02B014D1544CCB4370DEA44FC8A13B2F7DC354A22218C53FC310900925E74F43501BD5864B231210275E375F3E4A1BFFBDF6DDA060BACC6B7D2583964437583645D0F85533694B45E7029E33A75B00FFA967EC4CD3FE29D3C5D2EFFC19A44BAFE9B8C46792863F89B8B220F58B3EB2DA48FFC9CE024DA61EA2FF1A622D97EF5545B983E4F3E2B685A35606CA705AF936A2A4BC4F751009F41D944DF106760BD160BC7BF4DBE578E1AFD699DCE0179DBCC03F0CF7B5AD1BFF3C79D0D12EAA68CA43AAF6BDD4F74C44E51A1E"
                   , nil];
    
#endif

   
}


/**
 *  establish context
 */
-(void)createReaderContext
{
    readerDescription = [[ReaderInterface alloc] init];
    [readerDescription setDelegate:self];
    
    SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    
    [NSThread detachNewThreadSelector:@selector(getVersionInfo) toTarget:self withObject:nil];
   
    
}

/**
 *  get version
 */
-(void)getVersionInfo
{
    char firmwareRevision[32]={0};
    char hardwareRevision[32]={0};
    char libVersion[32]={0};
    FtGetLibVersion(libVersion);
    FtGetDevVer(0,firmwareRevision, hardwareRevision);
    
    __block NSString *softVersionString = [NSString stringWithFormat:@"Soft:%@",SoftVersion];
    __block NSString *sdkVersion =  [NSString stringWithFormat:@"SDK:%s",libVersion];
    __block NSString *firmVersionString = [NSString stringWithFormat:@"Firm:%s",firmwareRevision];
    dispatch_async(dispatch_get_main_queue(), ^{
        _softVersion.text = softVersionString;
        _SDKVersion.text = sdkVersion;
        _firmVersion.text = firmVersionString;
    });
}
/**
 *  add right item in navigationBar
 */
-(void)createButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_currentReaderName style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(displayVersionInfo:)];
}

-(void)back:(UIButton*)sender
{
    [readerDescription disConnectCurrentPeripheralReader];
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

-(void)displayVersionInfo:(UIButton *)sender
{
}

/**
 *  create file
 */
-(void)createFileSaveSeedBuffer
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docmentDirectory = [directoryPaths objectAtIndex:0];
    NSString *seedFilePath = [docmentDirectory stringByAppendingPathComponent:@"seed.txt"];
    NSString *flashFilePath = [docmentDirectory stringByAppendingPathComponent:@"flash.txt"];
    //1.create seed.text file
    if (![fileManager fileExistsAtPath:seedFilePath] ) {
        [fileManager createFileAtPath:seedFilePath contents:nil attributes:nil];
    }
    //2.create flash.text file
    if (![fileManager fileExistsAtPath:flashFilePath]) {
        [fileManager createFileAtPath:flashFilePath contents:nil attributes:nil];
    }
}


/**
 *  read file contents
 *
 *  @param fileName
 *
 *  @return
 */
-(NSData *)readFileContent:(NSString *)fileName
{
    NSData* fileData = nil;
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docmentDirectory = [directoryPaths objectAtIndex:0];
    NSString *filePath = [docmentDirectory stringByAppendingPathComponent:fileName];
    
    fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString *srcString = [[NSString alloc] initWithData:fileData  encoding:NSUTF8StringEncoding];;
    NSString *desString = [srcString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    fileData = [desString dataUsingEncoding:NSUTF8StringEncoding];
    return fileData;
    
}

/**
 *  card connect
 *
 *  @param sender
 */
-(IBAction)connectCard:(id)sender
{
    _atrTextView.text = @"";
    LONG iRet = 0;
    DWORD dwActiveProtocol = -1;
    char mszReaders[128] = "";
    
    if ([_currentReaderName length] != 0) {
        memcpy(mszReaders, _currentReaderName.UTF8String, _currentReaderName.length);
    }

    iRet = SCardConnect(gContxtHandle,mszReaders,SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1,&gCardHandle,&dwActiveProtocol);
    if (iRet != 0) {
        _atrTextView.text = [NSString stringWithFormat:@"%@\n",NSLocalizedString(@"connectError", nil)];
        _logTextView.text = [NSString stringWithFormat:@"%@\n",NSLocalizedString(@"connectError", nil)];
        return;
        
    }else {
        unsigned char patr[33];
        DWORD len = sizeof(patr);
        iRet = SCardGetAttrib(gCardHandle, 0, patr, &len);
        if(iRet != SCARD_S_SUCCESS)
        {
            NSLog(@"%@%08x",NSLocalizedString(@"cardGetAttribError",nil),iRet);
        }
        
        NSMutableData *tmpData = [NSMutableData data];
        [tmpData appendBytes:patr length:len];
        
        _atrTextView.text = [NSString stringWithFormat:@"ATR:%@",[tmpData description]];
        _logTextView.text =[NSString stringWithFormat:@"%@\n",NSLocalizedString(@"connectSuccess", nil)];
        
    }

}
/**
 *  card disconnect
 *
 *  @param sender 
 */
-(IBAction)disConnectCard:(id)sender
{
    LONG iRet = 0;
    iRet = SCardDisconnect(gCardHandle,SCARD_UNPOWER_CARD);
    if (iRet != 0) {
        _atrTextView.text = NSLocalizedString(@"disconnectError", nil);
        _logTextView.text = [_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@:%08x\n",NSLocalizedString(@"powerOffError", nil),iRet]];
    }
    else
    {
        _atrTextView.text = @"";
        _logTextView.text = [_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",NSLocalizedString(@"PowerOff Success", nil)]];
    }

}

/**
 *  send data
 *
 *  @param sender
 */
-(IBAction)sendCommand:(id)sender
{
    LONG iRet = 0;
    unsigned  int capdulen;
    unsigned char capdu[2056];
    unsigned char resp[2056];
    unsigned int resplen = sizeof(resp) ;
    
    //1.judge apdu length
    if([_apduTextField.text length] < 5  )
    {
        _logTextView.text = [_logTextView.text  stringByAppendingString:NSLocalizedString(@"Invalid APDU", nil)];
        return;
    }

    //2.change the format of data
    NSData *apduData =[hex hexFromString:_apduTextField.text];
    [apduData getBytes:capdu length:apduData.length];
    capdulen = (unsigned int)[apduData length];
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    iRet=SCardTransmit(gCardHandle,&pioSendPci, (unsigned char*)capdu, capdulen,NULL,resp, &resplen);
     _logTextView.text = [_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"send", nil),_apduTextField.text]];
    if (iRet != 0) {
       
        _logTextView.text = [_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@%08x\n",NSLocalizedString(@"Rec:", nil),iRet]];
        return;
    }
    else {
        
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        _logTextView.text = [_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rec:", nil),[RevData description]]];
    }
    

}


-(IBAction)dispostList:(id)sender
{
    if (_commandListView != nil) {
        _commandListView.hidden = !_commandListView.hidden;
    }
}

/**
 *  write UID
 *
 *  @param sender 
 */
-(IBAction)writeReaderUID:(id)sender
{
    NSData *fileData = [self readFileContent:@"seed.txt"];
    if ([fileData length] == 0) {
        _logTextView.text = NSLocalizedString(@"seed is nil", nil);
        return;
    }
    
    unsigned char seedBuffer[64] = {0};
    unsigned int seedLength = 0;
    LONG iRet = 0;

    seedLength =(unsigned int)fileData.length;
    
    iRet =  filterStr((char *)[fileData bytes], seedLength);
    if (iRet != 0) {
        _logTextView.text = NSLocalizedString(@"the format of seed data error", nil);
        return;
    }
    
    seedLength = seedLength/2;
    StrToHex(seedBuffer, (char *)[fileData bytes], seedLength);
    
    iRet = FtGenerateDeviceUID(gContxtHandle,seedLength,seedBuffer);
    if(iRet != 0 ){
        _logTextView.text = NSLocalizedString(@"writeUID ERROR", nil);
    }else {
        _logTextView.text = NSLocalizedString(@"writeUID Successful", nil);
    }

}

/**
 *  read UID
 *
 *  @param sender
 */
-(IBAction)readReaderUID:(id)sender
{
   
    char buffer[20] = {0};
    unsigned int length = sizeof(buffer);
    LONG iRet = FtGetDeviceUID(gContxtHandle,&length, buffer);
    if(iRet != 0 ){
        _logTextView.text = NSLocalizedString(@"readUID Error.\n", nil);
    }else {
        NSData *temp = [NSData dataWithBytes:buffer length:length];
        _logTextView.text = [NSString stringWithFormat:@"%@\n", temp];
    }

}

/**
 *  erase UID
 *
 *  @param sender
 */
-(IBAction)eraseReaderUID:(id)sender
{
    NSData *fileData = [self readFileContent:@"seed.txt"];
    if ([fileData length] == 0) {
        _logTextView.text = NSLocalizedString(@"seed is nil", nil);
        return;
    }

    unsigned char seedBuffer[64] = {0};
    unsigned int seedLength = 0;
    LONG iRet = 0;
    
    seedLength =(unsigned int)fileData.length;
    iRet =  filterStr((char *)[fileData bytes], seedLength);
    if (iRet != 0) {
        _logTextView.text = NSLocalizedString(@"the format of seed data error", nil);
        return;
    }
    
    seedLength = seedLength/2;
    StrToHex(seedBuffer, (char *)[fileData bytes], seedLength);

    iRet = FtEraseDeviceUID(gContxtHandle,seedLength,seedBuffer);
    if(iRet != 0 ){
        _logTextView.text = NSLocalizedString(@"eraseUID Error", nil) ;
    }else {
        _logTextView.text = NSLocalizedString(@"eraseUID Successful", nil) ;
    }

}

/**
 *  write FLASH
 *
 *  @param sender
 */
-(IBAction)writeReaderFlash:(id)sender
{
    NSData *fileData = [self readFileContent:@"flash.txt"];
    if ([fileData length] == 0) {
        _logTextView.text = NSLocalizedString(@"flash data is nil", nil) ;
        return;
    }
    
    unsigned char buffer[1024] = {0};
    unsigned int length = 0;
    LONG iRet = 0;
    
    length = (unsigned int)fileData.length;
   
    iRet =  filterStr((char *)[fileData bytes], length);
    if (iRet != 0) {
        _logTextView.text = NSLocalizedString(@"the format of flash data error", nil) ;
        return;
    }
    
    length = length/2;
    StrToHex(buffer, (char *)[fileData bytes], length);
    
    iRet = FtWriteFlash(gContxtHandle,0,length, buffer);
    if(iRet != 0 ){
        _logTextView.text = NSLocalizedString(@"writeFlash ERROR", nil) ;
    }else {
        _logTextView.text = NSLocalizedString(@"writeFlash Successful", nil) ;
    }

}

/**
 *  read FLASH
 *
 *  @param sender
 */
-(IBAction)readReaderFlash:(id)sender
{
    unsigned char buffer[256] = {0};
    unsigned int length = 255;
    LONG iRet = FtReadFlash(gContxtHandle,0,&length, buffer);
    if(iRet != 0 ){
        _logTextView.text = NSLocalizedString( @"readFlash Error", nil);
    }else {
        NSData *temp = [NSData dataWithBytes:buffer length:length];
        _logTextView.text = [NSString stringWithFormat:@"%@\n", temp];
    }
}

/**
 *  get card status
 *
 *  @param sender
 */
-(IBAction)getCardStatus:(id)sender
{
    DWORD dwState;
    LONG rv = 0;
    rv = SCardStatus(gContxtHandle, NULL, NULL, &dwState, NULL, NULL, NULL );
    if (rv != 0) {
        _logTextView.text = [NSString stringWithFormat:@"%@%4x\n",NSLocalizedString(@"SCardStatus return Error ", nil),rv];
    }
    
    switch (dwState) {
        case SCARD_ABSENT:
            _logTextView.text = @"The card has absent.\n";
            _cardStatus.on = NO;
            break;
        case SCARD_PRESENT:
            _logTextView.text = @"The card has present.\n";
            _cardStatus.on = YES;
            break;
        case SCARD_SWALLOWED:
            _logTextView.text = @"The Card not powered.\n";
            _cardStatus.on = YES;
            break;
            
        default:
            break;
    }

}

/**
 *  read HID
 *
 *  @param sender 
 */
-(IBAction)getReaderHID:(id)sender
{
    char buffer[20] = {0};
    unsigned int length = sizeof(buffer);
    LONG iRet = FtGetSerialNum(gContxtHandle,&length, buffer);
    if(iRet != 0 ){
        _logTextView.text = NSLocalizedString(@"Get device HID ERROR", nil) ;
    }else {
        NSData *temp = [NSData dataWithBytes:buffer length:length];
        _logTextView.text = [NSString stringWithFormat:@"%@\n", temp];
    }
}

#pragma mark - ReaderInterfaceDelegate
-(void)cardInterfaceDidDetach:(BOOL)attached
{
    dispatch_async(dispatch_get_main_queue(), ^{
       _cardStatus.on = attached;
    });
    
}
-(void)readerInterfaceDidChange:(BOOL)attached
{
    if (!attached) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}
-(void)findPeripheralReader:(NSString *)readerName
{

}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [commandList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = commandList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _apduTextField.text = commandList[indexPath.row];
    _commandListView.hidden = YES;
}

#pragma mark - UITextFeild Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

    if (theTextField == _apduTextField) {
        [_apduTextField resignFirstResponder];
    }
    return YES;
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
