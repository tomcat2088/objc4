#include "test.h"
#include <objc/runtime.h>
#include <dlfcn.h>
#include <unistd.h>
#include <pthread.h>
#include <Foundation/Foundation.h>

@interface TargetClass : NSObject
@end

@interface TargetClass(LoadedMethods)
- (void) m0;
- (void) m1;
- (void) m2;
- (void) m3;
- (void) m4;
- (void) m5;
- (void) m6;
- (void) m7;
- (void) m8;
- (void) m9;
- (void) m10;
- (void) m11;
- (void) m12;
- (void) m13;
- (void) m14;
- (void) m15;
@end

@implementation TargetClass
+(void)initialize { } 
+(id)new {
    return class_createInstance(self, 0);
}
- (void) m0; { fail("shoulda been loaded!"); }
- (void) m1; { fail("shoulda been loaded!"); }
- (void) m2; { fail("shoulda been loaded!"); }
- (void) m3; { fail("shoulda been loaded!"); }
- (void) m4; { fail("shoulda been loaded!"); }
- (void) m5; { fail("shoulda been loaded!"); }
- (void) m6; { fail("shoulda been loaded!"); }
@end

void *threadFun(void *aTargetClassName) {
    const char *className = aTargetClassName;

    objc_registerThreadWithCollector();

    NSAutoreleasePool *p = [NSAutoreleasePool new];

    Class targetSubclass = objc_getClass(className);
    testassert(targetSubclass);

    id target = [targetSubclass new];
    testassert(target);

    while(1) {
	[target m0];
	[target retain];
	[target addObserver: target forKeyPath: @"m3" options: 0 context: NULL];
	[target addObserver: target forKeyPath: @"m4" options: 0 context: NULL];
	[target m1];
	[target release];
	[target m2];
	[target autorelease];
	[target m3];
	[target retain];
	[target removeObserver: target forKeyPath: @"m4"];
	[target addObserver: target forKeyPath: @"m5" options: 0 context: NULL];
	[target m4];
	[target retain];
	[target m5];
	[target autorelease];
	[target m6];
	[target m7];
	[target m8];
	[target m9];
	[target m10];
	[target m11];
	[target m12];
	[target m13];
	[target m14];
	[target m15];
	[target removeObserver: target forKeyPath: @"m3"];
	[target removeObserver: target forKeyPath: @"m5"];
    }
    [p drain];
    return NULL;
}

int main()
{
    int i;

    void *dylib;

    for(i=1; i<16; i++) {
	pthread_t t;
	char dlName[100];
	sprintf(dlName, "cc%d.out", i);
	dylib = dlopen(dlName, RTLD_LAZY);
	char className[100];
	sprintf(className, "cc%d", i);
	pthread_create(&t, NULL, threadFun, strdup(className));
	testassert(dylib);
    }
    sleep(1);

    succeed(__FILE__);
}
