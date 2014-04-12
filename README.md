# FastMappingKit

[![Build Status](https://travis-ci.org/Yalantis/FastMappingKit.png)](https://travis-ci.org/Yalantis/FastMappingKit)

### Note
This is fork of [EasyMapping](https://github.com/lucasmedeirosleite/EasyMapping) - flexible and easy way of JSON mapping.

## Reason to be
It turns out, that almost all popular libraries for JSON mapping SLOW. The main reason is often trips to database during lookup of existing objects. So we [decided](http://yalantis.com/blog/2014/03/17/from-json-to-core-data-fast-and-effectively/) to take already existing [flexible solution](https://github.com/lucasmedeirosleite/EasyMapping) and improve overall performance. 
<p align="center" >
  <img src="https://raw.githubusercontent.com/Yalantis/FastMappingKit/master/Assets/com.yalantis.FastMappingKit.performance.png" alt="FastMappingKit" title="FastMappingKit">
</p>

# Usage
## Deserialization. NSManagedObject

Supose you have these classes:

```objective-c
@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber *personID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) Car *car;
@property (nonatomic, retain) NSSet *phones;

@end

@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber *carID;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) Person *person;

@end

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSNumber *phoneID;
@property (nonatomic, retain) NSString *ddi;
@property (nonatomic, retain) NSString *ddd;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) Person *person;

@end
```

Mapping can be described in next way:

```objective-c
@implementation MappingProvider

+ (FEMManagedObjectMapping *)personMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Person" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping setPrimaryKey:@"personID"];  // object uniquing

		[mapping addAttributeMappingDictionary:@{@"personID": @"id"}];
		[mapping addAttributeMappingFromArray:@[@"name", @"email", @"gender"]];

		[mapping addRelationshipMapping:[self carMapping] forProperty:@"car" keyPath:@"car"];
		[mapping addToManyRelationshipMapping:[self phoneMapping] forProperty:@"phones" keyPath:@"phones"];
	}];
}

+ (FEMManagedObjectMapping *)carMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Car" configuration:^(FEMManagedObjectMapping *mapping) {
    [mapping setPrimaryKey:@"carID"];

		[mapping addAttributeMappingFromArray:@[@"model", @"year"]];
	}];
}

+ (FEMManagedObjectMapping *)phoneMapping {
	return [FEMManagedObjectMapping mappingForEntityName:@"Phone" configuration:^(FEMManagedObjectMapping *mapping) {
		[mapping addAttributeMappingDictionary:@{@"phoneID" : @"id"}];
		[mapping addAttributeMappingFromArray:@[@"number", @"ddd", @"ddi"]];
	}];
}

@end
```


Converting a NSDictionary or NSArray to a object class or collection now becomes easy:

```objective-c
Person *person = [FEMManagedObjectDeserializer deserializeObjectExternalRepresentation:externalRepresentation
                                                                          usingMapping:[MappingProvider personMapping]
                                                                               context:context];
                                                                               
NSArray *cars = [FEMManagedObjectDeserializer deserializeCollectionExternalRepresentation:externalRepresentation
                                                                             usingMapping:[MappingProvider carMapping]
                                                                                  context:moc];
```


Filling an existent object:

```objective-c
Person *person = // fetch somehow;

FEMManagedObjectMapping *mapping = [MappingProvider personMapping];
[FEMManagedObjectDeserializer fillObject:person fromExternalRepresentation:externalRepresentation usingMapping:mapping];
```


## Deserialization. NSObject

If you are using NSObject use `FEMObjectMapping` instead of `FEMManagedObjectMapping` and  `FEMObjectDeserializer` instead of `FEMManagedObjectDeserializer`.

## Serialization

For both NSManagedObject and NSObject serialization to JSON looks the same:

```objective-c
NSDictionary *representation = [FEMSerializer serializeObject:car usingMapping:[MappingProvider carMapping]];
NSArray *collectionRepresentation = [FEMSerializer serializeCollection:cars usingMapping:[MappingProvider carMapping]];
```

# Roadmap
* Add relationship mapping policy (ie. assign, merge, replace).

# Thanks
* Special thanks to [lucasmedeirosleite](https://github.com/lucasmedeirosleite) for amazing framework.

# Extra
Read out [blogpost](http://yalantis.com/blog/2014/03/17/from-json-to-core-data-fast-and-effectively/) about FastMappingKit.
