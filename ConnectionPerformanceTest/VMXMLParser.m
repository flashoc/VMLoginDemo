//
//  VMXMLParser.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMXMLParser.h"
#import "GDataXMLNode.h"
#import "VMApplication.h"
#import "VMIcon.h"

static NSDictionary *_resultDic = nil;

@implementation VMXMLParser

+ (NSDictionary *)getResultDic{
    return _resultDic;
}

+ (NSDictionary *)responseOfDoLogout:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *logoutElement = [[rootElement elementsForName:@"logout"] objectAtIndex:0];
        GDataXMLElement *resultElement = [[logoutElement elementsForName:@"result"] objectAtIndex:0];
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultElement stringValue],[resultElement name], nil];
        
        if ([[resultElement stringValue] isEqualToString:@"error"]){
            
            GDataXMLElement *errcElement = [[logoutElement elementsForName:@"error-code"] objectAtIndex:0];
            GDataXMLElement *errmsgElement = [[logoutElement elementsForName:@"error-message"] objectAtIndex:0];
            [dic setObject:[errcElement stringValue] forKey:[errcElement name]];
            [dic setObject:[errmsgElement stringValue] forKey:[errmsgElement name]];
            
        }
        
        _resultDic = dic;
        return dic;
    }
    return nil;
}

+ (NSDictionary *)responseOfSetLocaleAndGetConfig:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *setLocaleElement = [[rootElement elementsForName:@"set-locale"] objectAtIndex:0];
        GDataXMLElement *resultElement = [[setLocaleElement elementsForName:@"result"] objectAtIndex:0];
        
        if (![[resultElement stringValue] isEqualToString:@"ok"]) {
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultElement stringValue],[resultElement name], nil];
            _resultDic = dic;
            return dic;
        }
        else{
            GDataXMLElement *configElement = [[rootElement elementsForName:@"configuration"] objectAtIndex:0];
            GDataXMLElement *resultElement0 = [[configElement elementsForName:@"result"] objectAtIndex:0];
            if ([[resultElement0 stringValue] isEqualToString:@"ok"]) {
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultElement0 stringValue],[resultElement0 name], nil];
                GDataXMLElement *authElement = [[configElement elementsForName:@"authentication"] objectAtIndex:0];
                GDataXMLElement *scrElement = [[authElement elementsForName:@"screen"] objectAtIndex:0];
                GDataXMLElement *nameElement = [[scrElement elementsForName:@"name"] objectAtIndex:0];
                [dic setObject:[nameElement stringValue] forKey: [nameElement name]];
                GDataXMLElement *parsElement = [[scrElement elementsForName:@"params"] objectAtIndex:0];
                GDataXMLElement *parElement = [[parsElement elementsForName:@"param"] objectAtIndex:0];
                GDataXMLElement *namElement = [[parElement elementsForName:@"name"] objectAtIndex:0];
                if ([[namElement stringValue] isEqualToString:@"domain"]) {
                    GDataXMLElement *valsElement = [[parElement elementsForName:@"values"] objectAtIndex:0];
                    GDataXMLElement *valElement = [[valsElement elementsForName:@"value"] objectAtIndex:0];
                    [dic setObject:[valElement stringValue] forKey: [namElement stringValue]];
                }
            }
            else if ([[resultElement stringValue] isEqualToString:@"error"]){
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultElement stringValue],[resultElement name], nil];
                GDataXMLElement *errcElement = [[configElement elementsForName:@"error-code"] objectAtIndex:0];
                GDataXMLElement *errmsgElement = [[configElement elementsForName:@"error-message"] objectAtIndex:0];
                [dic setObject:[errcElement stringValue] forKey:[errcElement name]];
                [dic setObject:[errmsgElement stringValue] forKey:[errmsgElement name]];
                
            }
            _resultDic = dic;
            return dic;
        }
    }
    return nil;
}

+ (NSDictionary *)responseOfSetLocale:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *setLocaleElement = [[rootElement elementsForName:@"set-locale"] objectAtIndex:0];
        GDataXMLElement *resultlement = [[setLocaleElement elementsForName:@"result"] objectAtIndex:0];
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
        _resultDic = dic;
        return dic;
    }
    return nil;
}

+ (NSDictionary *)responseOfGetConfiguration:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *configElement = [[rootElement elementsForName:@"configuration"] objectAtIndex:0];
        GDataXMLElement *resultElement = [[configElement elementsForName:@"result"] objectAtIndex:0];
        
        if ([[resultElement stringValue] isEqualToString:@"ok"]) {
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultElement stringValue],[resultElement name], nil];
            GDataXMLElement *authElement = [[configElement elementsForName:@"authentication"] objectAtIndex:0];
            GDataXMLElement *scrElement = [[authElement elementsForName:@"screen"] objectAtIndex:0];
            GDataXMLElement *nameElement = [[scrElement elementsForName:@"name"] objectAtIndex:0];
            [dic setObject:[nameElement stringValue] forKey: [nameElement name]];
            GDataXMLElement *parsElement = [[scrElement elementsForName:@"params"] objectAtIndex:0];
            GDataXMLElement *parElement = [[parsElement elementsForName:@"param"] objectAtIndex:0];
            GDataXMLElement *namElement = [[parElement elementsForName:@"name"] objectAtIndex:0];
            if ([[namElement stringValue] isEqualToString:@"domain"]) {
                GDataXMLElement *valsElement = [[parElement elementsForName:@"values"] objectAtIndex:0];
                GDataXMLElement *valElement = [[valsElement elementsForName:@"value"] objectAtIndex:0];
                [dic setObject:[valElement stringValue] forKey: [namElement stringValue]];
            }
        }
        else if ([[resultElement stringValue] isEqualToString:@"error"]){
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultElement stringValue],[resultElement name], nil];
            GDataXMLElement *errcElement = [[configElement elementsForName:@"error-code"] objectAtIndex:0];
            GDataXMLElement *errmsgElement = [[configElement elementsForName:@"error-message"] objectAtIndex:0];
            [dic setObject:[errcElement stringValue] forKey:[errcElement name]];
            [dic setObject:[errmsgElement stringValue] forKey:[errmsgElement name]];
            
        }
        _resultDic = dic;
        return dic;
    }
    return nil;
}

+ (NSDictionary *)responseOfAuthentication:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *submitElement = [[rootElement elementsForName:@"submit-authentication"] objectAtIndex:0];
        GDataXMLElement *resultlement = [[submitElement elementsForName:@"result"] objectAtIndex:0];
        
        if ([[resultlement stringValue] isEqualToString:@"ok"]) {
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
        }
        else if ([[resultlement stringValue] isEqualToString:@"partial"]){
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
            GDataXMLElement *authElement = [[submitElement elementsForName:@"authentication"] objectAtIndex:0];
            GDataXMLElement *scrElement = [[authElement elementsForName:@"screen"] objectAtIndex:0];
            GDataXMLElement *nameElement = [[scrElement elementsForName:@"name"] objectAtIndex:0];
            [dic setObject:[nameElement stringValue] forKey:[nameElement name]];
            GDataXMLElement *parsElement = [[scrElement elementsForName:@"params"] objectAtIndex:0];
            NSArray *arrayElement = [parsElement elementsForName:@"param"];
            for (GDataXMLElement *e in arrayElement) {
                GDataXMLElement *namElement = [[e elementsForName:@"name"] objectAtIndex:0];
                if ([[namElement stringValue] isEqualToString:@"error"]) {
                    GDataXMLElement *valsElement = [[e elementsForName:@"values"] objectAtIndex:0];
                    GDataXMLElement *valElement = [[valsElement elementsForName:@"value"] objectAtIndex:0];
                    [dic setObject:[valElement stringValue] forKey: [namElement stringValue]];
                }
            }
        }
        else if ([[resultlement stringValue] isEqualToString:@"error"]){
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
            GDataXMLElement *errcElement = [[submitElement elementsForName:@"error-code"] objectAtIndex:0];
            [dic setObject:[errcElement stringValue] forKey:[errcElement name]];
            GDataXMLElement *errmElement = [[submitElement elementsForName:@"error-message"] objectAtIndex:0];
            [dic setObject:[errmElement stringValue] forKey:[errmElement name]];
            GDataXMLElement *usrmElement = [[submitElement elementsForName:@"user-message"] objectAtIndex:0];
            [dic setObject:[usrmElement stringValue] forKey:[usrmElement name]];
        }
        _resultDic = dic;
        return dic;
    }
    return nil;
}

+ (NSDictionary *)responseOfGetTunnelAndLaunchItems:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *tunnelElement = [[rootElement elementsForName:@"tunnel-connection"] objectAtIndex:0];
        GDataXMLElement *resultlement = [[tunnelElement elementsForName:@"result"] objectAtIndex:0];
        
        if (![[resultlement stringValue] isEqualToString:@"ok"]) {
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
            GDataXMLElement *bypasslement = [[tunnelElement elementsForName:@"bypass-tunnel"] objectAtIndex:0];
            [dic setObject:[bypasslement stringValue] forKey:[bypasslement name]];
        }
        else{
            GDataXMLElement *launchElement = [[rootElement elementsForName:@"launch-items"] objectAtIndex:0];
            GDataXMLElement *resultlement = [[launchElement elementsForName:@"result"] objectAtIndex:0];
            if ([[resultlement stringValue] isEqualToString:@"ok"]) {
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
                
                GDataXMLElement *desksElement = [[launchElement elementsForName:@"desktops"] objectAtIndex:0];
                GDataXMLElement *deskElement = [[desksElement elementsForName:@"desktop"] objectAtIndex:0];
                GDataXMLElement *deskNameElement = [[deskElement elementsForName:@"name"] objectAtIndex:0];
                [dic setObject:[deskNameElement stringValue] forKey:[deskElement name]];
                
                GDataXMLElement *appsElement = [[launchElement elementsForName:@"applications"] objectAtIndex:0];
                NSArray *appArrary = [appsElement elementsForName:@"application"];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (GDataXMLElement *app in appArrary) {
                    VMApplication *application = [[VMApplication alloc] init];
                    GDataXMLElement *appNameElement = [[app elementsForName:@"name"] objectAtIndex:0];
                    [application setName:[appNameElement stringValue]];
                    GDataXMLElement *versionElement = [[app elementsForName:@"version"] objectAtIndex:0];
                    [application setVersion:[versionElement stringValue]];
                    GDataXMLElement *pubElement = [[app elementsForName:@"publisher"] objectAtIndex:0];
                    [application setPublisher:[pubElement stringValue]];
                    GDataXMLElement *iconsElement = [[app elementsForName:@"icons"] objectAtIndex:0];
                    NSArray *icons = [iconsElement elementsForName:@"icon"];
                    for (GDataXMLElement *ic in icons) {
                        VMIcon *icon = [[VMIcon alloc] init];
                        [icon setPath:[[[ic elementsForName:@"path"] objectAtIndex:0] stringValue]];
                        [icon setWidth:[[[ic elementsForName:@"width"] objectAtIndex:0] stringValue]];
                        [icon setHeight:[[[ic elementsForName:@"height"] objectAtIndex:0] stringValue]];
                        [[application icons] addObject:icon];
                    }
                    [arr addObject:application];
                }
                [dic setObject:arr forKey:[appsElement name]];
            }
        }
        
        _resultDic = dic;
        return dic;
    }
    return nil;
}

+ (NSDictionary *)responseOfGetTunnelConnection:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *tunnelElement = [[rootElement elementsForName:@"tunnel-connection"] objectAtIndex:0];
        GDataXMLElement *resultlement = [[tunnelElement elementsForName:@"result"] objectAtIndex:0];
        if ([[resultlement stringValue] isEqualToString:@"ok"]) {
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
            GDataXMLElement *bypasslement = [[tunnelElement elementsForName:@"bypass-tunnel"] objectAtIndex:0];
            [dic setObject:[bypasslement stringValue] forKey:[bypasslement name]];
        }
        
        _resultDic = dic;
        return dic;
    }
    return nil;
}

+ (NSDictionary *)responseOfGetLaunchItems:(NSData *)xmlData{
    if (xmlData != nil) {
        NSMutableDictionary *dic = nil;
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        GDataXMLElement *launchElement = [[rootElement elementsForName:@"launch-items"] objectAtIndex:0];
        GDataXMLElement *resultlement = [[launchElement elementsForName:@"result"] objectAtIndex:0];
        if ([[resultlement stringValue] isEqualToString:@"ok"]) {
            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[resultlement stringValue],[resultlement name], nil];
            
            GDataXMLElement *desksElement = [[launchElement elementsForName:@"desktops"] objectAtIndex:0];
            GDataXMLElement *deskElement = [[desksElement elementsForName:@"desktop"] objectAtIndex:0];
            GDataXMLElement *deskNameElement = [[deskElement elementsForName:@"name"] objectAtIndex:0];
            [dic setObject:[deskNameElement stringValue] forKey:[deskElement name]];
            
            GDataXMLElement *appsElement = [[launchElement elementsForName:@"applications"] objectAtIndex:0];
            NSArray *appArrary = [appsElement elementsForName:@"application"];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (GDataXMLElement *app in appArrary) {
                VMApplication *application = [[VMApplication alloc] init];
                GDataXMLElement *appNameElement = [[app elementsForName:@"name"] objectAtIndex:0];
                [application setName:[appNameElement stringValue]];
                GDataXMLElement *versionElement = [[app elementsForName:@"version"] objectAtIndex:0];
                [application setVersion:[versionElement stringValue]];
                GDataXMLElement *pubElement = [[app elementsForName:@"publisher"] objectAtIndex:0];
                [application setPublisher:[pubElement stringValue]];
                GDataXMLElement *iconsElement = [[app elementsForName:@"icons"] objectAtIndex:0];
                NSArray *icons = [iconsElement elementsForName:@"icon"];
                for (GDataXMLElement *ic in icons) {
                    VMIcon *icon = [[VMIcon alloc] init];
                    [icon setPath:[[[ic elementsForName:@"path"] objectAtIndex:0] stringValue]];
                    [icon setWidth:[[[ic elementsForName:@"width"] objectAtIndex:0] stringValue]];
                    [icon setHeight:[[[ic elementsForName:@"height"] objectAtIndex:0] stringValue]];
                    [[application icons] addObject:icon];
                }
                [arr addObject:application];
            }
            [dic setObject:arr forKey:[appsElement name]];
        }
        
        _resultDic = dic;
        return dic;
    }
    return nil;
}
@end
