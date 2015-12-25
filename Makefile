CONFIG?=Debug

all:
	cd SushiHangover.AppleScript.Native; xcodebuild
	nuget restore
	mdtool build SushiHangover.AppleScript.sln

clean:
	cd SushiHangover.AppleScript.Native; xcodebuild clean
	xbuild /t:Clean ${ARGS}

test: all
	MONO_IOMAP=all nunit-console SushiHangover.AppleScript.Test/SushiHangover.AppleScript.Test.csproj

