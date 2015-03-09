#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();


target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().mainWindow().textFields()[0].textFields()[0].tap();
target.frontMostApp().keyboard().typeString("151004");
target.frontMostApp().mainWindow().textFields()[1].textFields()[0].tap();
target.frontMostApp().keyboard().typeString("1");
target.frontMostApp().navigationBar().rightButton().tap();
captureLocalizedScreenshot("0-Settings")

target.frontMostApp().navigationBar().buttons()["menu burger"].tap();
target.frontMostApp().mainWindow().tableViews()[1].tapWithOptions({tapOffset:{x:0.17, y:0.04}});
target.delay(4)
captureLocalizedScreenshot("2-Schedule")
target.frontMostApp().navigationBar().buttons()["weekly"].tap();
captureLocalizedScreenshot("3-Weekly")

target.frontMostApp().navigationBar().buttons()["menu burger"].tap();
captureLocalizedScreenshot("1-Menu")
