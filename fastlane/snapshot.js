#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

var navBar = window.navigationBar();
var navBarButtons = navBar.buttons();
target.delay(3)
captureLocalizedScreenshot("0-LandingScreen")

navBarButtons[0].tap();

target.delay(1)
captureLocalizedScreenshot("1-LandingScreen")
