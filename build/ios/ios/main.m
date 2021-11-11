#define INFILE_NUM 2
#define WIDTH "352"
#define HEIGHT "288"
#define INPUT_BIT_DEPTH "8"
#define VERBOSE "2"
#define FPS_NUMBER "25"
#define FPS_DEN "1"
#define VERBOSE "2"

char infile[INFILE_NUM][128]={ // base dir: app/documents
    "akiyo_cif.yuv",
    "abr_hpm4.0/Traffic_2560x1600_30_7000kbps.avs3"
};


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "config.h"

int main(int argc, char * argv[]) {
    NSString* NsInputFileName, *NsInputFileFullName, *NsOutputFileName, *NsOutputFileFullName,*NsRecFileName, *NsRecFileFullName;
    char InputFileName[256], OutputFileName[256], RecFileName[256];
    unsigned long strLen;
        
    NSString * NsDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"path:   %@",NsDocuments);
    char* uavs3e_argv[17];
    int uavs3e_argc = 17;
    char decfile[64] = "dec.yuv";
    char recfile[64] = "rec.yuv";
    int j=0;
    
    for(int i = 0; i < INFILE_NUM; i++)
    {
        j = 0;
        NsInputFileName = [[NSString alloc]initWithCString:(const char *) (infile[i]) encoding:NSUTF8StringEncoding];
        NsInputFileFullName = [NSString stringWithFormat:@"%@/%@", NsDocuments, NsInputFileName];
        strLen = [NsInputFileFullName length];
        [NsInputFileFullName getCString:InputFileName maxLength:strLen+1 encoding:NSUTF8StringEncoding];
        printf("stream: %s\n", infile[i]);
        
        NsOutputFileName = [[NSString alloc]initWithCString:(const char *) (decfile) encoding:NSUTF8StringEncoding];
        NsOutputFileFullName = [NSString stringWithFormat:@"%@/%@", NsDocuments, NsOutputFileName];
        strLen = [NsOutputFileFullName length];
        [NsOutputFileFullName getCString:OutputFileName maxLength:strLen+1 encoding:NSUTF8StringEncoding];
        
        NsRecFileName = [[NSString alloc]initWithCString:(const char *) (recfile) encoding:NSUTF8StringEncoding];
        NsRecFileFullName = [NSString stringWithFormat:@"%@/%@", NsDocuments, NsRecFileName];
        strLen = [NsRecFileFullName length];
        [NsRecFileFullName getCString:RecFileName maxLength:strLen+1 encoding:NSUTF8StringEncoding];
        
        uavs3e_argv[j++] = "uavs3e";
        uavs3e_argv[j++] = "-i";
        uavs3e_argv[j++] = InputFileName;
        uavs3e_argv[j++] = "-o";
        uavs3e_argv[j++] = OutputFileName;
        uavs3e_argv[j++] = "-r";
        uavs3e_argv[j++] = RecFileName;
        uavs3e_argv[j++] = "-w";
        uavs3e_argv[j++] = WIDTH;
        uavs3e_argv[j++] = "-h";
        uavs3e_argv[j++] = HEIGHT;
        uavs3e_argv[j++] = "-d";
        uavs3e_argv[j++] = INPUT_BIT_DEPTH;
        uavs3e_argv[j++] = "--fps_num";
        uavs3e_argv[j++] = FPS_NUMBER;
        uavs3e_argv[j++] = "--fps_den";
        uavs3e_argv[j++] = FPS_DEN;
        uavs3e_decode_sample(uavs3e_argc, uavs3e_argv);
    }

    return 0;
}
