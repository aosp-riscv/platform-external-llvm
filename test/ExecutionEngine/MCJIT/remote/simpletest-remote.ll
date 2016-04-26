; RUN: %lli -remote-mcjit -mcjit-remote-process=lli-child-target%exeext %s > /dev/null
; XFAIL: mingw32,win32,powerpc64-unknown-linux-gnu
; Remove XFAIL for powerpc64-unknown-linux-gnu if problem caused by r266663 is fixed

define i32 @bar() nounwind {
	ret i32 0
}

define i32 @main() nounwind {
	%r = call i32 @bar( )		; <i32> [#uses=1]
	ret i32 %r
}
