using NUnit.Framework;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using AppleScript;

namespace AppleScript.Test
{
	[TestFixture ()]
	public class Test
	{
//		[Test ()]
//		public void TestCase ()
//		{
//		}

		[Test ()]
		public void ScriptFileReturnValue ()
		{
			string scpt = "./AppleScripts/ReturnValue.txt";
			var scptInfo = new FileInfo (scpt);
			string scriptResult;
			var result =  AppleScript.Run (scptInfo, null, null, out scriptResult, true);
			Assert.AreEqual (true, result);
			Assert.AreEqual("Hello from AppleScript", scriptResult);
		}

		[Test ()]
		public void ScriptFileFunctionExecuteTrue ()
		{
			string scpt = "./AppleScripts/FunctionTests.txt";
			var scptInfo = new FileInfo (scpt);
			string funcName = "IsRunning";
			// Finder on OS-X should always be running
			List<string> argList = new List<string> () {
				@"Finder",
			};
			string scriptResult;
			var result = AppleScript.Run (scptInfo, funcName, argList, out scriptResult);
			Assert.AreEqual (true, result);
			Assert.AreEqual ("true", scriptResult);
		}

		[Test ()]
		public void ScriptFileFunctionExecuteFalse ()
		{
			var scriptFileInfo = new FileInfo ("./AppleScripts/FunctionTests.txt");
			string funcName = "IsRunning";
			// Always fail to find this app
			List<string> argList = new List<string> () {
				@"AppDoesNotExist",
			};
			string scriptReturnValue;
			var executionSuccess = AppleScript.Run (scriptFileInfo, funcName, argList, out scriptReturnValue);
			Assert.AreEqual (true, executionSuccess);
			Assert.AreEqual ("false", scriptReturnValue);
		}

		[Test ()]
		public void ScriptFileFunctionDoesNotExist ()
		{
			var scriptFileInfo = new FileInfo ("./AppleScripts/FunctionTests.txt");
			var funcName = "DoesNotExistFunction";
			var argList = new List<string> () {
				@"FooBarFunction",
			};
			string scriptReturnValue;
			var executionSuccess = AppleScript.Run (scriptFileInfo, funcName, argList, out scriptReturnValue);
			Assert.AreEqual (false, executionSuccess);
			Assert.AreEqual ("-1708", scriptReturnValue);
		}

		[Test ()]
		public void ScriptFileFunctionParseFailure ()
		{
			var scriptFileInfo = new FileInfo ("./AppleScripts/ScriptFailure.txt");
			string scriptReturnValue;
			var executionSuccess = AppleScript.Run (scriptFileInfo, null, null, out scriptReturnValue, false);
			Assert.AreEqual (false, executionSuccess);
			Assert.AreEqual ("A identifier can’t go after this identifier.", scriptReturnValue);
		}

		[Test ()]
		public void ScriptFileFunctionScriptError ()
		{
			var scriptFileInfo = new FileInfo ("./AppleScripts/ScriptError.txt");
			string scriptReturnValue;
			var executionSuccess = AppleScript.Run (scriptFileInfo, null, null, out scriptReturnValue, false);
			Assert.AreEqual (false, executionSuccess);
			Assert.AreEqual ("Can’t get application \"DoesNotExist\".", scriptReturnValue);
		}

		[Test ()]
		public void ScriptFileFunctionInOut ()
		{
			var scriptFileInfo = new FileInfo ("./AppleScripts/InOut.txt");
			var funcName = "InOut";
			var argList = new List<string> () {
				@"WhatGoesIn",
			};
			string scriptReturnValue;
			var executionSuccess = AppleScript.Run (scriptFileInfo, funcName, argList, out scriptReturnValue, false);
			Assert.AreEqual (true, executionSuccess);
			Assert.AreEqual ("WhatGoesIn", scriptReturnValue);
		}

		[Test ()]
		[ExpectedException(typeof(System.IO.FileNotFoundException))]
		public void ScriptFileFunctionFileDoesNotExist ()
		{
			var scriptFileInfo = new FileInfo ("./AppleScripts/DOESNOTEXIST.txt");
			string scriptReturnValue;
			AppleScript.Run (scriptFileInfo, null, null, out scriptReturnValue, false);
		}

		[Test ()]
		public void ScriptStringFunctionInOut ()
		{
			var scriptString = "do shell script \"uname -a\"";
			string scriptReturnValue;
			var executionSuccess = AppleScript.Run (scriptString, null, null, out scriptReturnValue, false);
			Assert.AreEqual (true, executionSuccess);
			Assert.AreEqual ("Darwin", scriptReturnValue.StartsWith("Darwin"));
		}
	}
}

