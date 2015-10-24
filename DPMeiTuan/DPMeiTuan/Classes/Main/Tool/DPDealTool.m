//
//  DPDealTool.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/21.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDealTool.h"
#import "FMDB.h"
#import "DPDeal.h"

@implementation DPDealTool
static FMDatabase *_db;
+ (void)initialize
{
    // 打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (NSArray *)collectDeals:(int)page
{
    int size = 20;
    int pose = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pose, size];
    
    NSMutableArray *deals = [NSMutableArray array];
    while ([set next]) {
        DPDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    
    return deals;
}

+ (void)addCollectDeal:(DPDeal *)deal
{
    NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", dealData, deal.deal_id];
}

+ (void)removeCollectDeal:(DPDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id=%@;", deal.deal_id];
}

+ (BOOL)isCollected:(DPDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id=%@;", deal.deal_id];
    [set next];
    return [set intForColumn:@"deal_count"] == 1;
    
}

+ (int)collectDealsCount
{
    FMResultSet *set = [_db executeQuery:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
@end
