﻿using System;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using MonoMac.Foundation;

namespace SushiHangover
{
	public class AppleScriptResult
	{
		public bool Result {
			get;
			set;
		}

		public string Value {
			get;
			set;
		}
	}

	public static class AppleScript
	{
		const string ASELib = ASE.ASELib;

		//FOUNDATION_EXPORT BOOL ExecuteScriptFromString (NSString* scriptString, NSString* functionName, NSArray* argumentArray, char* scriptReturn, BOOL debug);
		[DllImport (ASELib, CharSet = CharSet.Auto)]
		static extern bool ExecuteScriptFromString (IntPtr scriptString, IntPtr functionName, IntPtr scriptArguments, StringBuilder scriptReturn, bool debug = false);

		//FOUNDATION_EXPORT BOOL ExecuteScriptFromFile (NSString* path, NSString* functionName, NSArray* argumentArray, char* scriptReturn, BOOL debug);
		[DllImport (ASELib, CharSet = CharSet.Auto)]
		static extern bool ExecuteScriptFromFile (IntPtr path, IntPtr functionName, IntPtr scriptArguments, StringBuilder scriptReturn, bool debug = false);

		public static bool Run (string scriptString, string scriptFunction, List<string> scriptArguments, out string scriptResult, bool debug = false)
		{
			var aScript = new NSString (scriptString);
			var aFunctionName = new NSString ((scriptFunction != null ? scriptFunction : ""));
			var aScriptArguments = new NSMutableArray ();
			if (scriptArguments != null) {
				foreach (var arg in scriptArguments) {
					aScriptArguments.Add (new NSString (arg));
				}
			}
			StringBuilder aReturn = new StringBuilder (256);
			debug = isEnvDebuggingSet (debug);
			var result = ExecuteScriptFromString (aScript.Handle, aFunctionName.Handle, aScriptArguments.Handle, aReturn, debug);
			scriptResult = aReturn.ToString ();
			return result;
		}

		public static async Task<AppleScriptResult> RunAsync (string scriptString, string scriptFunction, List<string> scriptArguments, bool debug = false)
		{
			Func<AppleScriptResult> runAsyncFunc = new Func<AppleScriptResult> (() => {
				string scriptReturnString;
				var success = Run (scriptString, scriptFunction, scriptArguments, out scriptReturnString, debug);
				var foo = new AppleScriptResult (){ Result = success, Value = scriptReturnString };
				return foo;
			});
			AppleScriptResult scriptResults = await Task.Run<AppleScriptResult> (runAsyncFunc);
			return scriptResults;
		}

		public static bool Run (FileInfo scriptPath, string scriptFunction, List<string> scriptArguments, out string scriptResult, bool debug = false)
		{
			if (!scriptPath.Exists) {
				throw new System.IO.FileNotFoundException ();
			}
			var aPath = new NSString (scriptPath.FullName);
			var aFunctionName = new NSString ((scriptFunction != null ? scriptFunction : ""));
			var aScriptArguments = new NSMutableArray ();
			if (scriptArguments != null) {
				foreach (var arg in scriptArguments) {
					aScriptArguments.Add (new NSString (arg));
				}
			}
			StringBuilder aReturn = new StringBuilder (256);
			debug = isEnvDebuggingSet (debug);
			debug = true;
			var result = ExecuteScriptFromFile (aPath.Handle, aFunctionName.Handle, aScriptArguments.Handle, aReturn, debug);
			scriptResult = aReturn.ToString ();
			return result;
		}

		public static async Task<AppleScriptResult> RunAsync (FileInfo scriptPath, string scriptFunction, List<string> scriptArguments, bool debug = false)
		{
			Func<AppleScriptResult> runAsyncFunc = new Func<AppleScriptResult> (() => {
				string scriptReturnString;
				var success = Run (scriptPath, scriptFunction, scriptArguments, out scriptReturnString, debug);
				var foo = new AppleScriptResult (){ Result = success, Value = scriptReturnString };
				return foo;
			});
			AppleScriptResult scriptResults = await Task.Run<AppleScriptResult> (runAsyncFunc);
			return scriptResults;
		}

		static bool isEnvDebuggingSet (bool debug)
		{
			if (!debug) {
				var debugEnv = Environment.GetEnvironmentVariable ("APPLE_SCRIPT_DEBUG");
				if (debugEnv == "true")
					debug = true;
			}
			return debug;
		}
	}
}

