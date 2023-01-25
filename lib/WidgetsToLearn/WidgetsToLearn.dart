

/*

Positioned,
InkWell,
Card,
Opacity,
PageView,
Switch,
CustomClipper() with Path(),



WillPopScope(
onWillPop : () async {
// Back button pressed!

// return false == stay on page
// return true == pop

final shouldPop = await showMyDialog();
return shouldPop ?? false; // if dialog is activated, back button wont work. else back button will do pop. for this Navigator.of(context).pop(context, false) and Navigator.of(context).pop(context, true)  will be used.
}
)


Padding(
padding: EdgeInsets.all(16).copyWith(bottom : 0),
child : Text("Hey"),
)


 */