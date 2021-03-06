//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import "YelpBusiness.h"

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
NSString * const kYelpConsumerKey = @"_SyHDW6rW_YFV8SbrUS5jw";
NSString * const kYelpConsumerSecret = @"hnUr1aQQYIVyS5wa6zc3KdiyQEI";
NSString * const kYelpToken = @"V-492ic0gWf_Rkf03NNRdhBFvV6YYNzS";
NSString * const kYelpTokenSecret = @"WorHcSRNd_KUAmIU-PBwcALao3Q";

@interface YelpClient ()

@end

@implementation YelpClient

// Singleton
+ (instancetype)sharedInstance {
    static YelpClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YelpClient alloc] init];
    });
    return instance;
}

- (instancetype)init {
    NSURL *baseURL = [NSURL URLWithString:@"https://api.yelp.com/v2/"];
    if (self = [super initWithBaseURL:baseURL consumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret]) {
        
        BDBOAuth1Credential *token = [BDBOAuth1Credential credentialWithToken:kYelpToken
                                                                       secret:kYelpTokenSecret
                                                                   expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                completion:(void (^)(NSArray *businesses, NSError *error))completion {
    
    return [self searchWithTerm:term
                       sortMode:YelpSortModeBestMatched
                     categories:nil
                       distance:0
                          deals:NO
                     completion:completion];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                  sortMode:(YelpSortMode)sortMode
                                categories:(NSArray *)categories
                                  distance:(float)distance
                                     deals:(BOOL)hasDeal
                                completion:(void (^)(NSArray *businesses, NSError *error))completion {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSMutableDictionary *parameters = [@{@"term": term,
                                         @"ll" : @"37.774866,-122.394556",
                                         @"sort": [NSNumber numberWithInt:sortMode]}
                                       mutableCopy];

    if (distance) {
        // Convert Miles to Meters
        // Max 40,000 Meters (25 Miles)
        float distanceInMeters = distance / 0.00062137;
        if (distanceInMeters > 40000) {
            distanceInMeters = 40000;
        }
        parameters[@"distance_filter"] = [NSString stringWithFormat:@"%.f", distanceInMeters];
    }
    if (categories && categories.count > 0) {
        parameters[@"category_filter"] = [categories componentsJoinedByString:@","];
    }
    
    if (hasDeal) {
        parameters[@"deals_filter"] = [NSNumber numberWithBool:hasDeal];
    }
    
    NSLog(@"%@", parameters);
    
    return [self GET:@"search"
          parameters:parameters
             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                 
                 NSArray *businesses = responseObject[@"businesses"];
                 completion([YelpBusiness businessesFromJsonArray:businesses], nil);
                 
             } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                 completion(nil, error);
                 NSLog(@"Error: %@", error);
             }];
}

@end
