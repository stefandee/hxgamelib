This is version 2.6 of MochiAd.as and examples.

Please contact team@mochiads.com or visit our community forums at
http://www.mochiads.com/community/ if you have any questions or comments.

For instructions, please see the README.html file in the 'docs' folder in this archive.

New in 2.6:
- Fixed issue when using MochiCrypt with AS3 API

New in 2.5:
- Documentation includes click-away ads

New in 2.4:

- New showClickAwayAd function for click-away ads
- New no_progress_bar option to disable the progress bar
- New ad_progress callback to get percentage of ad show completion or game load whichever is more

New in 2.3:

- New ad_loaded callback to get ad dimensions when the ad is loaded
- New ad_failed callback to get notification when an ad failed to load due to ad blocking or network failure

New in 2.2:

- More readable error reporting in thrown exceptions with regards to the clip parameter
- Memory usage improvements in the as3 API
- New AS3 Flex SDK 2 example

New in 2.1:

- Fixed Preloader.as in mxmlc example, no longer throws exception if
  there's a partial load (navigate away from the page while loading)
- Much improved as3 example, built in the same style as the as2 example.

New in 2.0:
    
- Fixed unhandled exceptions in ActionScript 3 API
- Renamed MochiAd.showPreloaderAd to MochiAd.showPreGameAd
- Renamed MochiAd.showTimedAd to MochiAd.showInterLevelAd

Contents:

as1/
    ActionScript 1 compatible MochiAd code and example FLA.

as2/
    ActionScript 2 compatible MochiAd code and example FLA.

as3/
    ActionScript 3 compatible MochiAd code and example FLA.

mtasc/
    MTASC compatible ActionScript 2 code and example project.

mxmlc/
    Flex 2 SDK compatible ActionScript 3 code and example project.
    
Note that while we officially support Flash 7 and above, the MochiAd code
is currently Flash 6 compatible.

(c) 2006-2007 Mochi Media, Inc.
