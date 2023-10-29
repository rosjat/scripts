using System;
using System.Runtime.InteropServices;
using System.Security;

namespace RandomStuffModule.Cmdlet.HPiLo;

internal static class IloHelper
{
	internal static string SecureStringToString(SecureString value)
	{
		IntPtr valuePtr = IntPtr.Zero;
		try
		{
			valuePtr = Marshal.SecureStringToGlobalAllocUnicode(value);
			return Marshal.PtrToStringUni(valuePtr);
		}
		finally
		{
			Marshal.ZeroFreeGlobalAllocUnicode(valuePtr);
		}
	}

}