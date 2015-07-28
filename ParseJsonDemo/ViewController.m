//
//  ViewController.m
//  ParseJsonDemo
//
//  Created by deveplopper on 15/7/21.
//  Copyright (c) 2015年 deveplopper. All rights reserved.
//

#import "ViewController.h"
@interface ViewController (){
    NSMutableDictionary *dict;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView = [[UITableView alloc]
                       initWithFrame:CGRectMake(0, 40, self.view.frame.size.width,self.view.frame.size.height)
                       style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    [self.myTableView setDataSource:self];
    [self.view addSubview:self.myTableView];
    [self NetConnection];
}

-(void) NetConnection{
    
    //网络请求操作
    //1、设置请求路径
    NSString *urlStr = @"http://api.map.baidu.com/telematics/v3/movie?qt=hot_movie&location=宁波&ak=xdNGHZ7gNe4seMxWar2E7bCE&output=json";
    //将url字符串处理成urlwithstring能接受的形式
    NSString *webStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStr];
    //2、创建请求对象
    
    NSMutableURLRequest  *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0;
    
    //3、发送请求
    NSOperationQueue *queue  = [[NSOperationQueue alloc]init];//将网络加载数据放入该线程
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         NSLog(@"block回调函数");
//         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         //NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
         if ([jsonObject isKindOfClass:[NSDictionary class]]) {
             dict = [[NSMutableDictionary alloc]initWithDictionary: (NSDictionary *) jsonObject];
         }else if ([jsonObject isKindOfClass:[NSArray class]]){
             NSArray *arr = (NSArray *) jsonObject;
         }
    
         NSMutableDictionary *resultDict =  [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)[dict objectForKey:@"result"]];
         self.movieList =  [[NSMutableArray alloc]initWithArray:[resultDict objectForKey:@"movie"]];
         
         //NSLog(@"dom解析结束！");
         //返回到主线程刷新数据
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.myTableView reloadData ];
         });
     }];
}

#pragma mark TableView Delegate Method

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [[UITableViewCell alloc]init];
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"CellIdentifier"];
    }
    NSMutableDictionary *movie = self.movieList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"《%@》 导演：%@ 评分：%@",[movie objectForKey:@"movie_name"],
                           [movie objectForKey:@"movie_director"],[movie objectForKey:@"movie_score"]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.movieList count];
}




@end
