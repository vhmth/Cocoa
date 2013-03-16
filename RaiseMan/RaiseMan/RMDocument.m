//
//  RMDocument.m
//  RaiseMan
//
//  Created by Vinay Siddharam Hiremath on 3/16/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import "RMDocument.h"
#import "Person.h"

@implementation RMDocument

static void *RMDocumentKVOContext;

- (void)startObservingPerson:(Person *)person {
    [person addObserver:self
             forKeyPath:@"name"
                options:NSKeyValueObservingOptionOld
                context:&RMDocumentKVOContext];
    
    [person addObserver:self
             forKeyPath:@"expectedRaise"
                options:NSKeyValueObservingOptionOld
                context:&RMDocumentKVOContext];
}

- (void)stopObservingPerson:(Person *)person {
    [person removeObserver:self
                forKeyPath:@"name"
                   context:&RMDocumentKVOContext];
    
    [person removeObserver:self
                forKeyPath:@"expectedRaise"
                   context:&RMDocumentKVOContext];
}

- (id)init
{
    self = [super init];
    if (self) {
        employees = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setEmployees:(NSMutableArray *)manifest {
    for (Person *p in employees) {
        [self stopObservingPerson:p];
    }
    employees = manifest;
    for (Person *p in employees) {
        [self startObservingPerson:p];
    }
}

- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index {
    NSLog(@"adding %@ to %@", p, employees);
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]
                            removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add Person"];
    }
    
    [self startObservingPerson:p];
    [employees insertObject:p atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(NSUInteger)index {
    Person *p = [employees objectAtIndex:index];
    NSLog(@"removing %@ from %@", p, employees);
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p
                                       inEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove Person"];
    }
    
    [self stopObservingPerson:p];
    [employees removeObjectAtIndex:index];
}

- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    NSLog(@"oldValue = %@", oldValue);
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:oldValue];
    [undo setActionName:@"Edit"];
}

- (IBAction)createEmployee:(id)sender {
    NSWindow *w = [tableView window];
    
    BOOL editingEnded = [w makeFirstResponder:w];
    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }
    NSUndoManager *undo = [self undoManager];
    
    if ([undo groupingLevel] > 0) {
        [undo endUndoGrouping];
        [undo beginUndoGrouping];
    }
    
    Person *p = [employeeController newObject];
    [employeeController addObject:p];
    [employeeController rearrangeObjects];
    
    NSArray *a = [employeeController arrangedObjects];
    NSUInteger row = [a indexOfObjectIdenticalTo:p];

    NSLog(@"starting edit of %@ in row %lu", p, row);
    [tableView editColumn:0
                      row:row
                withEvent:nil
                   select:YES];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError *__autoreleasing *)outError {
    NSLog(@"About to read data of type %@", typeName);
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException *e) {
        NSLog(@"exception = %@", e);
        if (outError) {
            NSDictionary *d = [NSDictionary
                               dictionaryWithObject:@"The data is corrupted."
                                             forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                            code:unimpErr
                                        userInfo:d];
        }
        return NO;
    }
    [self setEmployees:newArray];
    return YES;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController {
    [super windowControllerDidLoadNib:windowController];
}

- (NSString *)windowNibName {
    return @"RMDocument";
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName
                 error:(NSError **)outError {
    [[tableView window] endEditingFor:nil];
    return [NSKeyedArchiver archivedDataWithRootObject:employees];
}

@end
