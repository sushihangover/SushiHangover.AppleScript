# Sushi.AppleScript

[https://github.com/sushihangover/Sushi.AppleScript](https://github.com/sushihangover/Sushi.AppleScript)

The C# library allows you to execute AppleScript code that originates from a file or `string` and: 

* Call function by name (Optional)
* Pass multiple arguments to a function (Optional)
* Execution success or failure
* Return results from the function call

####Example:

	var scptInfo = new FileInfo ("./AppleScripts/FunctionTests.txt");
	string funcName = "IsRunning";
	List<string> argList = new List<string> () {
		@"Finder",
	};
	string scriptReturnValue;
	var executionSuccess = AppleScript.Run (scptInfo, funcName, argList, out scriptReturnValue);


###Supports:

* MonoMac
* Xamarin.Mac
* i386 and x86_64 Mono Support

###Runtime/Deployment debugging:

Runtime/Deployment debugging available by setting an environment variable, `APPLE_SCRIPT_DEBUG`:

`export APPLE_SCRIPT_DEBUG=true`

The results are logged with the prefix `AppleScript:`, output is avaiable via Console.app.

###Sushi.AppleScript

The C# library that provides the P/Invoke wrapper to execute AppleScript functions

###Sushi.AppleScript.Native

An OS-X Universial (i386 & x86_64) Shared Library:

* `libAppleScriptEvent.dylib`

####Sushi.AppleScript.Test

NUnit tests for Sushi.AppleScript library

####Sushi.AppleScript.CLI

TODO: Provides an `osascript` style CLI utility to execute functions with AppleScript files (`osascript` does not contain this feature)

###License:

* The MIT License (MIT)


