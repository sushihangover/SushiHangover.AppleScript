# Sushi.AppleScript

[https://github.com/sushihangover/Sushi.AppleScript](https://github.com/sushihangover/Sushi.AppleScript)

The C# library allows you to execute AppleScript code that originates from a file or `string` and: 

* Call function by name (Optional)
* Pass multiple arguments to a function (Optional)
* Execution success or failure
* Return results from the function call

### Build:

	cd SushiHangover.AppleScript.Native
	xcodebuild
	cd -
	nuget restore
	xbuild SushiHangover.AppleScript.sln
	
**Note:**

	AppleScript.cs(7,7): error CS0246: The type or namespace name `MonoMac' could not be found. Are you missing an assembly reference?

If you do not have a local copy of [MonoMac](https://github.com/mono/monomac), xbuild will fail. It is available via "Xamarin Studio" so you can biuld from the cmd line via:

	mdtool build SushiHangover.AppleScript.sln

### Test:

**Mono's supplied nunit-console:**

	MONO_IOMAP=all nunit-console SushiHangover.AppleScript.Test/SushiHangover.AppleScript.Test.csproj

**NUnit 3.x console:**

	mono $(MTOOLS)/nunit3-console.exe SushiHangover.AppleScript.Test/SushiHangover.AppleScript.Test.csproj


####Example Usage:

	var scptInfo = new FileInfo ("./AppleScripts/FunctionTests.txt");
	string funcName = "IsRunning";
	List<string> argList = new List<string> () {
		@"Finder",
	};
	string scriptReturnValue;
	var executionSuccess = AppleScript.Run (scptInfo, funcName, argList, out scriptReturnValue);

* Consult [Test.cs](https://github.com/sushihangover/Sushi.AppleScript/blob/master/Sushi.AppleScript.Test/Test.cs) for more examples

###Supports:

* MonoMac
* Xamarin.Mac
* i386 and x86_64 Mono Support

###Runtime/Deployment debugging:

Runtime/Deployment debugging available by setting an environment variable, `APPLE_SCRIPT_DEBUG`:

`export APPLE_SCRIPT_DEBUG=true`

The results are logged with the prefix `AppleScript:`, output is avaiable via Console.app.

###SushiHangover.AppleScript

The C# library that provides the P/Invoke wrapper to execute AppleScript functions

###SushiHangover.AppleScript.Native

An OS-X Universial (i386 & x86_64) Shared Library:

* `libAppleScriptEvent.dylib`

###SushiHangover.AppleScript.Test

NUnit tests for Sushi.AppleScript library

###SushiHangover.AppleScript.CLI

TODO: Provides an `osascript` style CLI utility to execute functions with AppleScript files (`osascript` does not contain this feature)

###License:

* The MIT License (MIT)


