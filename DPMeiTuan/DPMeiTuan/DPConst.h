
#ifdef DEBUG
#define DPLog(...) NSLog(__VA_ARGS__)
#else
#define DPLog(...)
#endif

#define DPColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DPGlobalBg DPColor(230, 230, 230)